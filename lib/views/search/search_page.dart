import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/actions.dart';
import 'package:sun_be_gone/bloc/app_bloc.dart';
import 'package:sun_be_gone/bloc/bus_routes_bloc.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/views/search/directions_search.dart';
import 'package:sun_be_gone/views/search/lines_search.dart';
import 'package:sun_be_gone/views/search/routes_list_view.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class SearchPage extends StatefulWidget {
  DateTime selectedTime;
  String? selectedDeparture;
  String? selectedDestination;
  String? selectedLine;
  OnRoutePicked onRoutePicked;
  //Iterable<BusRoutes?>? routes;
  SearchPage({
    super.key,
    required this.onRoutePicked,
    required this.selectedTime,
    // required this.routes,
  });
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedTabIndex = 0; // To keep track of the selected tab index

  //return a text widget of dateTime
  Widget buildDateTime() {
    print('building date time');
    if (widget.selectedTime.day == DateTime.now().day) {
      return Row(
        children: [
          Text(
            'Departure at ${widget.selectedTime.hour}:${widget.selectedTime.minute} ',
          ),
          const Icon(
            Icons.arrow_drop_down,
          ),
        ],
      );
    } else {
      return Text(
        'Departure at ${widget.selectedTime.day}/${widget.selectedTime.month}, ${widget.selectedTime.hour}:${widget.selectedTime.minute} ',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('building search page');
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Shadow color
                offset: Offset(
                    5, 0), // Offset controls the direction (right in this case)
                blurRadius: 5, // Adjust the blur radius as needed
              ),
            ],
          ),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //white space
                const SizedBox(height: 20),
                // Tabs for Directions, Lines, and Stations
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    SizedBox(
                        height: 35,
                        width: 110,
                        child: buildTabButton('Directions', 0)),
                    const SizedBox(width: 10),
                    SizedBox(
                        height: 35,
                        width: 110,
                        child: buildTabButton('Lines', 1)),
                  ],
                ),
                const SizedBox(height: 20),
                // Content based on the selected tab
                //Expanded(
                //echild:
                Column(
                  children: <Widget>[
                    SizedBox(
                        child: _selectedTabIndex == 0
                            ? buildDirectionsSearch()
                            : buildLinesSearch())
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton(
                      onPressed: () => DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        onConfirm: (date) {
                          context
                              .read<AppBloc>()
                              .add(DateTimePickedAction(dateTime: date));
                        },
                        currentTime: widget.selectedTime,
                      ),
                      child: buildDateTime(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: BlocConsumer<BusRotuesBloc, BusRoutesState>(
              listener: (context, state) {
            if (state.error != null) {
              //context.read<AppBloc>().add(ErrorAction(error: state.error!));
              context.read<AppBloc>().add(const NoRouteFoundAction());
            }
            if (state.busRoutes.isEmpty) {
              print('routes was empty from search page');
              context.read<BusRotuesBloc>().add(const GetBusRoutesAction());
            }
          }, builder: (context, state) {
            if (state.busRoutes.isEmpty) const Text('No routes found');
            return RoutesListView(
              routes: state.busRoutes,
              onRoutePicked: widget.onRoutePicked,
            );
          }),
        ),
      ],
    );
  }

  // Helper method to build tab buttons
  Widget buildTabButton(String text, int index) {
    return _selectedTabIndex == index
        ? ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: null,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Center(child: Text(text)),
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Center(child: Text(text)),
          );
  }

  // Placeholder widgets for different search content
  Widget buildDirectionsSearch() {
    return DirectoinsSearch(
      onDepartureEditingComplete: (value) => context.read<BusRotuesBloc>().add(
          FilterBusRoutesAction(
              filterFunction: (route) =>
                  route!.routeDeparture!.contains(value!))),
      onDirectionEditingComplete: (value) => context.read<BusRotuesBloc>().add(
          FilterBusRoutesAction(
              filterFunction: (route) =>
                  route!.routeDestination!.contains(value!))),
    );
  }

  Widget buildLinesSearch() {
    return LinesSearch(
      onSubmittedLine: (value) => context.read<BusRotuesBloc>().add(
          FilterBusRoutesAction(
              filterFunction: (route) =>
                  route!.routeShortName.contains(value!))),
    );
  }
}
