import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sun_be_gone/models/bus_routes.dart';

typedef OnStopPicked = void Function();
typedef OnRoutePicked = void Function(int, DateTime);

class RoutesListView extends StatelessWidget {
  final Iterable<BusRoutes?> routes;
  final OnRoutePicked onRoutePicked;
  final DateTime dateTime;
  final bool isFavoritsList;
  final Function(String)? onSlidePressed;
  const RoutesListView({
    Key? key,
    required this.routes,
    required this.onRoutePicked,
    required this.dateTime,
    this.onSlidePressed,
    this.isFavoritsList = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: routes.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(routes.elementAt(index)!.routeId),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => onSlidePressed!(
                    routes.elementAt(index)!.routeId.toString()),
                label: isFavoritsList
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                icon: isFavoritsList ? Icons.delete : Icons.favorite_border,
                backgroundColor: isFavoritsList ? Colors.red : Colors.blue,
                foregroundColor: Colors.white,
              ),
            ],
          ),
          child: ListTile(
            title: Text(routes.elementAt(index)!.routeShortName),
            subtitle: Text(routes.elementAt(index)!.routeDestination!),
            onTap: () =>
                onRoutePicked(routes.elementAt(index)!.routeId, dateTime),
          ),
        );
      },
    );
  }
}

