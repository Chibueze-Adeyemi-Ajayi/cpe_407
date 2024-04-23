import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: const [
            Text(
              "Time Management App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                "This app is in partial fulfilment of the requirement for CPE407, software development technique.\nThe mobile app was designed following every specifications in functionality as regards a time management app"),
            SizedBox(
              height: 20,
            ),
            Text("version: 1.0.0"),
            Text("Platform: Android OS"),
            Text("Developers: CPE class'24 Group 1"),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "About",
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
      backgroundColor: Colors.cyan,
      surfaceTintColor: Colors.cyan,
    );
  }
}
