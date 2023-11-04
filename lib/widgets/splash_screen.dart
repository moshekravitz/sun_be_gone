import 'Package:flutter/material.dart';

@immutable
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          /*Image.asset(
              'assets/images/logo.png',
              height: 200,
              width: 200,
            ),*/
          Icon(
            Icons.directions_bus,
            color: Colors.green,
          ),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      )),
    );
  }
}
