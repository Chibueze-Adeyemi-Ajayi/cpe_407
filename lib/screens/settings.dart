import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        // ignore: sort_child_properties_last
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleWidget("Ringing Tone"),
              Row(
                children: [
                  const Text("Digital Tune"),
                  const SizedBox(
                    width: 20,
                  ),
                  Radio(value: 1, groupValue: 1, onChanged: (val) {})
                ],
              ),
              _titleWidget("Notification Type"),
              Row(
                children: [
                  const Text("Push Notification"),
                  const SizedBox(
                    width: 20,
                  ),
                  Radio(value: 1, groupValue: 1, onChanged: (val) {})
                ],
              ),
            ],
          ),
        ),
        physics: const BouncingScrollPhysics(),
      ),
    );
  }

  Column _titleWidget(String text) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          textAlign: TextAlign.left,
          text,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Settings",
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
