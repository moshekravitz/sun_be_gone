import 'package:flutter/material.dart';
import 'package:sun_be_gone/dialogs/stop_picker_dialog.dart';
import 'package:sun_be_gone/models/bus_routes.dart';

typedef OnStopPicked = void Function();
typedef OnRoutePicked = void Function(int routeId);

class RoutesListView extends StatelessWidget {
  final Iterable<BusRoutes?> routes;
  final OnRoutePicked onRoutePicked;
  const RoutesListView({
    Key? key,
    required this.routes,
    required this.onRoutePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: routes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(routes.elementAt(index)!.routeShortName),
          subtitle: Text(routes.elementAt(index)!.routeDestination!),
          onTap:() => onRoutePicked(routes.elementAt(index)!.routeId),
        );
      },
    );
  }
}
