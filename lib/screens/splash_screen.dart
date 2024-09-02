import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Image.asset('assets/images/whisper_connect.png'),
          const SizedBox(height: 30),
          const SpinKitWanderingCubes(
            size: 50,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
