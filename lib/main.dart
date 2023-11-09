import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sun_be_gone/ad_state.dart';
import 'package:sun_be_gone/services/server_connection_api.dart';
import 'package:sun_be_gone/views/app.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    final error = details.exception;
    final stackTrace = details.stack;

    // Log the error using your preferred logging package (e.g., Logger)
    final logger = Logger();
    logger.e("Error occurred: $error", stackTrace: stackTrace);

    // Send a POST request to your logging server
    ServerConnectionApi.sendErrorToServer(error, stackTrace);

    // You can also choose to crash the app by uncommenting the following line
    // FlutterError.dumpErrorToConsole(details, forceCrash: true);
  };

  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);



  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) {
        return const App();
      }
    ),
  );
}

