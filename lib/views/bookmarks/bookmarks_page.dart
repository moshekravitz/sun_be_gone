import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_be_gone/bloc/bookmarks_bloc.dart';
import 'package:sun_be_gone/bloc/date_time_cubit.dart';
import 'package:sun_be_gone/data/app_cache.dart';
import 'package:sun_be_gone/data/persistent_data.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sun_be_gone/views/search/routes_list_view.dart';
import 'package:sun_be_gone/widgets/build_date_time.dart';

class BookmarksPage extends StatelessWidget {
  //final Iterable<BusRoutes> historyRoutes;
  //final Iterable<BusRoutes> bookmarkedRoutes;
  final OnRoutePicked onRoutePicked;
  final Function(String) onSlidePressedAddFav;
  final Function(String) onSlidePressedRemoveFav;

  const BookmarksPage({
    super.key,
    required this.onRoutePicked,
    required this.onSlidePressedAddFav,
    required this.onSlidePressedRemoveFav,
  });//  : historyRoutes = AppCache.instance().historyBusRoutes ?? [],
      //  bookmarkedRoutes = AppCache.instance().bookmarksBusRoutes ?? [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateTimeCubit, DateTime>(builder: (context, dateTime) {
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.history, color: Colors.black)),
                Tab(icon: Icon(Icons.star, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 20),
            DateTimePickerButton(
              onConfirm: (date) {
                context.read<DateTimeCubit>().setDateTime(date);
              },
              dateTime: dateTime,
            ),
            Expanded(
              child: TabBarView(children: [
                BlocBuilder<RoutesHistoryCubit, Iterable<BusRoutes>>(
                    builder: (context, historyRoutes) {
                  return RoutesListView(
                    routes: historyRoutes,
                    onRoutePicked: onRoutePicked,
                    dateTime: dateTime,
                    onSlidePressed: onSlidePressedAddFav,
                  );
                }),
                BlocBuilder<BookMarksCubit, Iterable<BusRoutes>>(
                    builder: (context, bookmarkedRoutes) {
                  return RoutesListView(
                    onSlidePressed: onSlidePressedRemoveFav,
                    routes: bookmarkedRoutes,
                    onRoutePicked: onRoutePicked,
                    dateTime: dateTime,
                    isFavoritsList: true,
                  );
                }),
              ]),
            ),
          ],
        ),
      );
    });
  }
}
