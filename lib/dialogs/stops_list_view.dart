import 'package:flutter/material.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/models/route_quary_info.dart' show StopQuaryInfo;

class BusStop {
  final String name;
  bool isSelected;

  BusStop(this.name, this.isSelected);
}

@immutable
class StopsListView extends StatefulWidget {
  final Iterable<StopQuaryInfo> stops;
  //add callback for setting departure and destination indexes

  final void Function(int) setDepartureIndex;
  final void Function(int) setDestinationIndex;

  const StopsListView({super.key, 
    required this.stops,
    required this.setDepartureIndex,
    required this.setDestinationIndex,
  });

  @override
  _StopsListViewState createState() => _StopsListViewState();
}

class _StopsListViewState extends State<StopsListView> {
  late List<BusStop> busStops;
  int departureIndex = -1;
  int destinationIndex = -1;

  //init state
  @override
  void initState() {
    super.initState();
    busStops = widget.stops.map((e) => BusStop(e.stopName, false)).toList();
  }

  void selectStop(int index) {
    setState(() {
      if (departureIndex != -1 && destinationIndex != -1) {
        //both stops are already selected
        if (index == destinationIndex) {
          //deselect destination stop
          destinationIndex = -1;
          widget.setDestinationIndex(-1);
          busStops[index].isSelected = false;
        } else {
          //deselect both stops
          busStops[departureIndex].isSelected = false;
          busStops[destinationIndex].isSelected = false;
          departureIndex = -1;
          widget.setDepartureIndex(-1);
          destinationIndex = -1;
          widget.setDestinationIndex(-1);
        }
      } else if (departureIndex != -1) {
        //departure stop is already selected
        if (index == departureIndex) {
          //deselect departure stop
          busStops[index].isSelected = false;
          departureIndex = -1;
          widget.setDepartureIndex(-1);
        } else {
          //select destination stop
          destinationIndex = index;
          widget.setDestinationIndex(index);
          busStops[index].isSelected = true;
        }
      } else {
        //no stops are selected
        departureIndex = index;
        widget.setDepartureIndex(index);
        busStops[index].isSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Stops Selection"),
      ),
      body: ListView.builder(
        itemCount: busStops.length,
        itemBuilder: (context, index) {
          if (departureIndex != -1 && destinationIndex != -1) {
            if (index != departureIndex && index != destinationIndex) {
              return Container();
            }
          } else if (departureIndex != -1) {
            if (index < departureIndex) {
              return Container();
            }
          }
          final stop = busStops[index];
          return GestureDetector(
            onTap: () {
              selectStop(index);
            },
            child: Container(
              color: stop.isSelected ? Colors.blue[100] : Colors.transparent,
              child: ListTile(
                title: Text(stop.name),
              ),
            ),
          );
        },
      ),
    );
  }
}
