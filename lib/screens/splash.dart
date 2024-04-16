import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:time_management_app/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: 400,
        backgroundColor: Colors.cyan,
        splash: Stack(children: [
          const Center(child: Icon(Icons.alarm, color: Colors.white, size: 70)),
          Center(
            child: Container(
              // ignore: sort_child_properties_last
              child: const Text(
                "Time Management App",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
            ),
          )
        ]),
        nextScreen: const HomeScreen(),
        splashTransition: SplashTransition.scaleTransition,
        duration: 3000,
      ),
    );
  }
}
