import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class AddTaskWidget extends StatefulWidget {
  final FlutterSecureStorage storage;
  // final Function alarmFunction;
  const AddTaskWidget(
      {super.key, required this.storage /*, required this.alarmFunction*/});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  var selectedValue = "1";

  TextEditingController text_controller = TextEditingController();

  var selectedDate = null,
      task = null,
      selectedTime = null,
      taskCategory = null;

  String selectedTimeLabel = "Select Time", selectedDateLabel = "Choose Date";

  bool isLoading = false;

  int hour = 0, minute = 0;

  static void callback(int id) async {
    print(id);
    FlutterSecureStorage strg = await new FlutterSecureStorage();
    var value = await strg.read(key: id.toString());
    print(value);
    if (value == null) {
      return;
    }
    List<String> params = value.toString().split("|");
    await strg.write(key: "title", value: params[0]);
    print("Notification Reminder");
    List<String> data = value.toString().split("|");
    await strg.delete(key: id.toString());
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      category: NotificationCategory.Reminder,
      wakeUpScreen: true,
      id: id,
      channelKey: 'basic_channel',
      actionType: ActionType.KeepOnTop,
      title: 'Task Reminder',
      body: data[0],
      criticalAlert: true,
      fullScreenIntent: true,
    ));
    // _HomeScreenState
    // FlutterRingtonePlayer().playAlarm();
    // AndroidAlarmManager.channelName
  }

  List<String> searches = [
    "",
    "default",
    "personal",
    "shopping",
    "wishlist",
    "work"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        // ignore: sort_child_properties_last
        children: [
          // ignore: prefer_const_constructors
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const Text(
                "New Task",
                style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 18,
                    decoration: TextDecoration.none),
              ),
              Expanded(child: Container()),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.cyan,
                  ))
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
              controller: text_controller,
              maxLines: 5,
              style: const TextStyle(color: Colors.black),
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: .5),
                ),
                hintStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                hintText: "Enter Quick Task Here",
                iconColor: Colors.black,
                prefixIconColor: Colors.black,
              )),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () async {
                  selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(3001));
                  if (selectedDate == null) return;
                  print("Selected date $selectedDate");
                  setState(() {
                    selectedDateLabel =
                        (selectedDate.toString()).substring(0, 10);
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.cyan),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(selectedDateLabel,
                        style: TextStyle(color: Colors.cyan))
                  ],
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () async {
                  selectedTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (selectedTime == null) return;
                  TimeOfDay time = selectedTime;
                  hour = time.hour;
                  minute = time.minute;
                  print('$hour - $minute');
                  // Duration()
                  // ignore: use_build_context_synchronously
                  selectedTime = time.format(context);
                  setState(() {
                    selectedTimeLabel = selectedTime;
                  });
                  print("Selected time $selectedTime");
                },
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    const Icon(CupertinoIcons.clock_fill, color: Colors.cyan),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(selectedTimeLabel,
                        style: const TextStyle(color: Colors.cyan))
                  ],
                ),
              )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.cyan, borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
            width: double.infinity,
            child: DropdownButton<String>(
              dropdownColor: Colors.cyan,
              value: selectedValue, // Current selected value
              items: [
                _dropDownMenu("0", "Choose Task Category", Icons.menu),
                _dropDownMenu("1", "All category", Icons.menu),
                _dropDownMenu("2", "Default", CupertinoIcons.list_bullet),
                _dropDownMenu("3", "Personal", CupertinoIcons.list_bullet),
                _dropDownMenu("4", "Shopping", CupertinoIcons.list_bullet),
                _dropDownMenu("5", "Wishlist", CupertinoIcons.list_bullet),
                _dropDownMenu("6", "Work", CupertinoIcons.list_bullet),
                // _dropDownMenu("7", "Others", Icons.format_list_bulleted_add),
              ],
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                  int numb = int.parse(selectedValue);
                  if (numb == 0) numb = 1; // Update selected value
                  taskCategory = searches[numb - 1];
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // ignore: sized_box_for_whitespace
          Container(
              width: double.infinity,
              child: isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(
                          color: Colors.cyan,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Set border radius
                        ),
                        backgroundColor: Colors.cyan, // Set background color
                        foregroundColor:
                            Colors.white, // Set text color (optional)
                      ),
                      onPressed: () async {
                        task = text_controller.text;
                        if (task == "") {
                          alert("Please fill in a task");
                          return;
                        }
                        if (selectedDate == null) {
                          alert("Choose a date please");
                          return;
                        }
                        if (selectedTime == null) {
                          alert("Choose the time please");
                          return;
                        }
                        if (taskCategory == null) {
                          alert("Please choose category");
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        String data =
                            "$task|$selectedDate|$selectedTime|$taskCategory";
                        print(data);
                        String key = (const Uuid()).v1();
                        var index = await widget.storage.read(key: "index");
                        int id = index != null ? int.parse(index) : -1;
                        id += 1;
                        print("id $id");
                        List<String> dates = selectedDate.toString().split("-");
                        await widget.storage
                            .write(key: "index", value: id.toString());
                        await widget.storage
                            .write(key: id.toString(), value: data);
                        print(dates);
                        int year = int.parse(dates[0]),
                            month = int.parse(dates[1]),
                            day = int.parse(dates[2].substring(0, 3));
                        await AndroidAlarmManager.oneShotAt(
                            DateTime(year, month, day, hour, minute),
                            id,
                            params: {"uuid": key},
                            callback,
                            wakeup: true,
                            exact: true,
                            allowWhileIdle: true,
                            alarmClock: true);
                        print("Done .....");
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Row(
                          children: [
                            Icon(
                              Icons.alarm,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Task scheduled successfully")
                          ],
                        )));
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Save Task",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))
                          ],
                        ),
                      )))
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      // height: 600,
    );
  }

  DropdownMenuItem<String> _dropDownMenu(
      String val, String label, IconData icon) {
    return DropdownMenuItem<String>(
      value: val,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // String parseDate (String timeString) {
  //   // 1. Parse the time string
  //   int hours = int.parse(timeString.split(':')[0]);
  //   int minutes = int.parse(timeString.split(':')[1].split(' ')[0]);

  //   // 2. Handle AM/PM format (assuming 12-hour clock)
  //   if (timeString.contains('PM') && hours != 12) {
  //     hours += 12; // Convert to 24-hour format for PM times
  //   }

  //   // 3. Create a DateTime object with zero date (assuming only time matters)
  //   DateTime time = DateTime(year: 2000, month: 1, day: 1, hour: hours, minute: minutes);

  //   // 4. Convert to milliseconds (or format as desired)
  //   int milliseconds = time.millisecondsSinceEpoch;
  //   String formattedTime = time.toIso8601String();
  // }

  void alert(String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(msg),
              title: const Text("Time Management App"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"))
              ],
              icon: const Icon(CupertinoIcons.bell_fill),
            ));
  }

  void scheduleNotification() async {}
}
