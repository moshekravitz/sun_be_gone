import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sun_be_gone/ad_state.dart';
import 'package:sun_be_gone/views/homescreen/enter_search.dart';

class Home extends StatefulWidget {
  final OnSearchTapped onSearchTapped;

  const Home({super.key, required this.onSearchTapped});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: adState.bannerAdListener,
        )..load();
      });
    });
  }

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
                        EnterSearch(onSearchTapped: widget.onSearchTapped),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ad
          const SizedBox(
            height: 10,
          ),
          if (banner != null)
            Expanded(
              child: AdWidget(ad: banner!),
            )
          else
            const SizedBox(
              height: 50,
            ),
        ],
      ),
    );
  }
}
