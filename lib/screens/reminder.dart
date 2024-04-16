import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Container(
        child: Center(
          child: Container(
            height: 200,
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.alarm,
                  size: 45,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Task Reminder",
                  style: TextStyle(fontSize: 45),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
