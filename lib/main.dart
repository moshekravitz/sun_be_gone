import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:provider/provider.dart';
import 'package:sun_be_gone/ad_state.dart';
import 'package:sun_be_gone/services/server_connection_api.dart';
import 'package:sun_be_gone/utils/logger.dart';
import 'package:sun_be_gone/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stream loggerStream = Logger.addOutputListener().asBroadcastStream();
  String logs = '';
  loggerStream.listen((event) {
    if (event is OutputEvent) {
      logs += 'level: ${event.level}\n';
      logs += event.lines.join('\n');
    }
  });

/*
  FlutterError.onError = (details) async {
    logger.i('details context: ${details.context}');
    logger.e('FlutterError.onError stack: ${details.stack}', details.exception);
    //if app has no connection to the internet, then don't send error to server
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      return;
    }

    final error = details.exception;
    final stackTrace = details.stack;

    // Send a POST request to your logging server
    ServerConnectionApi.sendErrorToServer(error, stackTrace, logs);

    // You can also choose to crash the app by uncommenting the following line
    // FlutterError.dumpErrorToConsole(details, forceCrash: true);
  };
  */

  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  runApp(
    Provider.value(
        value: adState,
        builder: (context, child) {
          return const App();
        }),
  );
}
