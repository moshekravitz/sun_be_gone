import 'Package:flutter/material.dart';

@immutable
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          /*Image.asset(
              'assets/images/logo.png',
              height: 200,
              width: 200,
            ),*/
          const Icon(
            Icons.directions_bus,
            color: Colors.green,
            size: 150.0,
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(20.0),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      )),
    );
  }
}
