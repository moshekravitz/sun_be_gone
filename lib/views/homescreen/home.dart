import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sun_be_gone/ad_state.dart';
import 'package:sun_be_gone/utils/logger.dart';
import 'package:sun_be_gone/views/homescreen/enter_search.dart';

class Home extends StatelessWidget {
  final OnSearchTapped onSearchTapped;

  const Home({super.key, required this.onSearchTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 250,
            child: Stack(
              children: <Widget>[
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(
                        0.5), // Adjust the opacity to control the dimming effect
                    BlendMode
                        .dstATop, // This mode applies the filter on top of the image
                  ),
                  child: Image.asset(
                    'assets/maxresdefault-3375335936.jpg',
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Where are you headed today?',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        EnterSearch(onSearchTapped: onSearchTapped),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ad
          Expanded(
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: LayoutBuilder(builder: (context, constraints) {
                final containerHeight = constraints.maxHeight;
                final containerWidth = constraints.maxWidth;
                return HomeScreenAdWidget(
                    size: Size(containerWidth, containerHeight));
              }),
            ),
          )
        ],
      ),
    );
  }
}

class HomeScreenAdWidget extends StatefulWidget {
  final Size size;

  const HomeScreenAdWidget({super.key, required this.size});
  @override
  State<HomeScreenAdWidget> createState() => _HomeScreenAdWidgetState();
}

class _HomeScreenAdWidgetState extends State<HomeScreenAdWidget> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize(
            //width: MediaQuery.of(context).size.width.toInt(),
            width: widget.size.width.toInt(),
            height: widget.size.height.toInt(),
          ),
          request: const AdRequest(),
          listener: adState.bannerAdListener,
        )..load();
        logger.i(
            'banner size: hieght: ${banner!.size.height}, width: ${banner!.size.width}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (banner == null) ? const SizedBox() : AdWidget(ad: banner!);
  }
}
