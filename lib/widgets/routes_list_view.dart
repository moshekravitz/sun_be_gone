import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sun_be_gone/ad_state.dart';
import 'package:sun_be_gone/models/bus_routes.dart';

typedef OnStopPicked = void Function();
typedef OnRoutePicked = void Function(BusRoutes, DateTime);

class RoutesListView extends StatefulWidget {
  final Iterable<BusRoutes?> routes;
  final OnRoutePicked onRoutePicked;
  final DateTime dateTime;
  final bool isFavoritsList;
  final Function(BusRoutes)? onSlidePressed;
  const RoutesListView({
    Key? key,
    required this.routes,
    required this.onRoutePicked,
    required this.dateTime,
    this.onSlidePressed,
    this.isFavoritsList = false,
  }) : super(key: key);

  @override
  State<RoutesListView> createState() => _RoutesListViewState();
}

class _RoutesListViewState extends State<RoutesListView> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.fullBanner,
          request: const AdRequest(),
          listener: adState.bannerAdListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemCount: widget.routes.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 70,
                child: Slidable(
                  key: ValueKey(widget.routes.elementAt(index)!.routeId),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => widget.onSlidePressed!(
                            widget.routes.elementAt(index)!),
                        label: widget.isFavoritsList
                            ? 'Remove from favorites'
                            : 'Add to favorites',
                        icon: widget.isFavoritsList
                            ? Icons.delete
                            : Icons.favorite_border,
                        backgroundColor:
                            widget.isFavoritsList ? Colors.red : Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 5),
                        Container(
                            width: 70,
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.routes.elementAt(index)!.routeShortName,
                              style: const TextStyle(fontSize: 22),
                            )),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              //width: 200,
                              child: Text(
                                //routes.elementAt(index)!.routeLongName,
                                widget.routes.elementAt(index)!.prettyString(),
                                style: const TextStyle(fontSize: 14),
                                //maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                      ],
                    ),
                    onTap: () {
                      return widget.onRoutePicked(
                          widget.routes.elementAt(index)!,
                          widget.dateTime);
                    },
                  ),
                  /*child: ListTile(
                    title: Text(routes.elementAt(index)!.routeShortName),
                    subtitle: Text(routes.elementAt(index)!.routeDestination!),
                    onTap: () =>
                        onRoutePicked(routes.elementAt(index)!.routeId, dateTime),
                  ),
                  */
                ),
              );
            },
          ),
        ),
        banner != null
            ? SizedBox(
                height: 50,
                child: AdWidget(ad: banner!),
              )
            : const SizedBox(),
      ],
    );
  }
}
