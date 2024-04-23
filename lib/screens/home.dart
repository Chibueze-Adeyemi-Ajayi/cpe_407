// ignore_for_file: unused_field
// import 'dart:isolate';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:time_management_app/screens/reminder.dart';
import 'package:time_management_app/widgets/addTaskWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class NotificationController {
  static final player = AudioPlayer();

  void _isolateEntryPoint(SendPort sendPort) async {
    // Your isolate logic here
    final data = 'Data from isolate';
    sendPort.send(data); // Send data to the main isolate
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    // play audio and diaplay alert
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    // Create a player
    final duration = await player.setUrl(// Load a URL
        'https://unstructured-data.us-sea-1.linodeobjects.com/clock-alarm-8761.mp3'); // Schemes: (https: | file: | asset: )
    player.play();
    player.setLoopMode(LoopMode.all);
    sendBroadcast(
      BroadcastMessage(
          name: "time_management_app", data: {"id": receivedNotification.id}),
    );
    // sendPort.send(receivedNotification);
    print("notification created");
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    player.stop();
    print("Canceld");
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    player.stop();
    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
}

// void printHello() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
// }

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final storage = new FlutterSecureStorage();

  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "time_management_app",
    ],
  );

  AnimationController? _controller;
  Animation<double>? _animation;

  String selectedValue = "1";
  String _selectedValue = "1";

  bool canSearch = false;

  var alertTitle;

  void triggerSetState() {
    setState(() {});
  }

  bool canShowReminder = true;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    textController.addListener(() {
      print("Text xxxxxxxxxxxxxxxxxxxx");
      param = textController.value.text.toString();
      print("param $param");
      doStuff();
    });
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_controller as Animation<double>);
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else
        print("allowed ******************************************");
    });

    try {
      receiver.start();
      receiver.messages.listen((BroadcastMessage msg) async {
        var data = await storage.readAll();
        List<Widget> tiles_ = populateData(data);
        setState(() {
          tiles = tiles_;
        });
        if (canShowReminder) {
          print(
              "*******************************************************&&&&&&&&&");
          alert("Jilo Billionaire");
        }
        canShowReminder = false;
      }, onDone: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(new SnackBar(content: Text("Task reminder")));
      });
      // print("broadcast blabla bla");
    } catch (e) {
      print("error $e *****************************");
    } finally {
      super.initState();
    }
  }

  void doStuff() async {
    var data = await storage.readAll();
    List<Widget> tiles_ = populateData(data);
    setState(() {
      tiles = tiles_;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.resumed) {
    // App resumed from background
    // Reload data on resume
    // }
    doStuff();
  }

  // ..
  @override
  void dispose() {
    _controller!.dispose();
    receiver.stop();
    super.dispose();
  }

  int i = 1;

  Future<Map<String, String>> _loadData() async {
    print("loading data .....");
    return await storage.readAll();
  }

  List<Widget> populateData(data_) {
    List<Widget> tiles = [];
    int i = -1;

    for (var entry in data_.entries) {
      i++;
      print("1 ---------------- $i");
      String key = entry.key, value = entry.value;
      if (key == "index" || key == "title") continue;
      print("$key - $value");
      if (value.toLowerCase().indexOf(param.toLowerCase()) < 0) continue;
      List<String> details = value.split("|");

      tiles.add(ListTile(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(details[0]),
                content: const Text('Are you sure you want to delete Task?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false), // Cancel
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, true);
                      await storage.delete(key: key);
                      var data = await storage.readAll();
                      List<Widget> tiles_ = populateData(data);
                      setState(() {
                        tiles = tiles_;
                      });
                    }, // Confirm
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
        },
        leading: const Icon(Icons.alarm),
        title: Text(details[0]),
        // ignore: prefer_interpolation_to_compose_strings
        subtitle: Text(details[1].substring(0, 10) + " - " + details[2]),
      ));
    }
    return tiles;
  }

  List<Widget> tiles = [];
  void deleteItem(String itemName) {
    tiles.removeAt(0);
    setState(() {
      tiles = [];
    });
  }

  Widget buildDismissibleItem(
      String itemName, ListTile widget, BuildContext context) {
    return Dismissible(
      // Key for the item (unique identifier)
      key: Key(itemName),
      background: Container(
        // Background displayed when swiping
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        // Background on swipe in other direction (optional)
        color: Colors.green,
        child: Icon(Icons.archive, color: Colors.white),
      ),
      confirmDismiss: (direction) {
        // Callback for confirmation (optional)
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete Task?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), // Cancel
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  }, // Confirm
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: widget,
      onDismissed: (DismissDirection direction) {
        // Callback after dismissal
        if (direction == DismissDirection.endToStart) {
          print('Deleted: $itemName');
          deleteItem(itemName);
        } else {
          print('Archived: $itemName');
          deleteItem(itemName);
        }
        // Perform actions based on dismissal direction (optional)
      },
    );
  }

  bool popNow = false;
  Future<bool> _popFunc() async {
    // Conditions to allow or disallow back navigation
    if (!popNow) {
      ScaffoldMessenger.of(context)
          .showSnackBar(new SnackBar(content: Text("Click again to exit")));
      popNow = true;
      Future.delayed(Duration(seconds: 5)).then((value) {
        popNow = false;
      });
      return false;
    }
    return popNow;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return WillPopScope(
      onWillPop: _popFunc,
      child: Scaffold(
        appBar: canSearch ? _searchAppBar() : _myAppBar(),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          backgroundColor: Colors.white,
          elevation: 5,
          onPressed: () async {
            showModalBottomSheet();
          },
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.cyan,
          ),
        ),
        body: FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data_ = snapshot.data!;
              tiles = populateData(data_);

              // ignore: sort_child_properties_last
              return tiles.length < 1
                  ? Center(
                      // ignore: sized_box_for_whitespace
                      child: Container(
                        height: 200,
                        child: const Column(
                          children: [
                            Icon(Icons.alarm_add_sharp,
                                color: Colors.cyan, size: 60),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Add A Task",
                              style: TextStyle(
                                  fontSize: 25,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.cyan),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        var data = await storage.readAll();
                        List<Widget> tiles_ = populateData(data);
                        setState(() {
                          tiles = tiles_;
                        });
                      },
                      child: ListView(
                        children: tiles,
                        // physics: const BouncingScrollPhysics(),
                      ),
                    );
            } else if (snapshot.hasError) {
              print('Error loading data: ${snapshot.error}');
              return const Text('Error loading data');
            }
            // Display a loading indicator while data is fetched
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<void> showModalBottomSheet() async {
    var result = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => AddTaskWidget(
              storage: storage,
            ));
    if (result != null) {
      // Code to execute when the modal closes (indicated by non-null result)
      print(
          'Modal closed! ...................................................');
    } else {
      var data = await storage.readAll();
      List<Widget> tiles_ = populateData(data);
      setState(() {
        tiles = tiles_;
      });
    }
  }

  Future<void> showReminderModalBottomSheet() async {
    var result = await showMaterialModalBottomSheet(
        context: context, builder: (context) => ReminderScreen());
    if (result != null) {
      // Code to execute when the modal closes (indicated by non-null result)
      print(
          'Modal closed! ...................................................');
    } else {
      var data = await storage.readAll();
      List<Widget> tiles_ = populateData(data);
      setState(() {
        tiles = tiles_;
      });
      canShowReminder = true;
    }
  }

  AppBar _searchAppBar() {
    return AppBar(
      surfaceTintColor: Colors.cyan,
      elevation: 2,
      shadowColor: Colors.black,
      backgroundColor: Colors.cyan,
      title: AnimatedBuilder(
          animation: _animation!,
          builder: (context, child) => Transform.scale(
                scale: _animation!.value,
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  color: Colors.transparent,
                  child: Center(
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(color: Colors.white),
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w300),
                          hintText: "Search",
                          iconColor: Colors.white54,
                          prefixIconColor: Colors.white54,
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                ),
              )),
      leading: IconButton(
          onPressed: () {
            _controller!.reverse();
            param = "";
            doStuff();
            Future.delayed(const Duration(milliseconds: 250)).then((value) {
              setState(() {
                canSearch = false;
              });
            });
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
    );
  }

  List<String> searches = [
    "",
    "default",
    "personal",
    "shopping",
    "wishlist",
    "work"
  ];
  String param = "";

  AppBar _myAppBar() {
    return AppBar(
      surfaceTintColor: Colors.cyan,
      elevation: 2,
      shadowColor: Colors.black,
      backgroundColor: Colors.cyan,
      leading: const Icon(
        Icons.alarm,
        color: Colors.white,
      ),
      title: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: DropdownButton<String>(
          dropdownColor: Colors.cyan,
          value: selectedValue, // Current selected value
          items: [
            _dropDownMenu("1", "All List", Icons.home),
            _dropDownMenu("2", "Default", CupertinoIcons.list_bullet),
            _dropDownMenu("3", "Personal", CupertinoIcons.list_bullet),
            _dropDownMenu("4", "Shopping", CupertinoIcons.list_bullet),
            _dropDownMenu("5", "Wishlist", CupertinoIcons.list_bullet),
            _dropDownMenu("6", "Work", CupertinoIcons.list_bullet),
            // _dropDownMenu("6", "New List", Icons.format_list_bulleted_add),
          ],
          onChanged: (value) {
            setState(() {
              selectedValue = value!; // Update selected value
              if (selectedValue != null) {
                int i = int.parse(selectedValue);
                param = searches[i - 1];
                print("param $param");
              }
            });
          },
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              _controller!.forward();
              Future.delayed(const Duration(seconds: 0)).then((value) {
                setState(() {
                  canSearch = true;
                });
              });
            },
            icon: const Icon(
              CupertinoIcons.search,
              color: Colors.white,
            )),
        PopupMenuButton<String>(
          color: Colors.cyan,
          icon: const Icon(Icons.more_vert),
          iconColor: Colors.white,
          onSelected: (value) {
            Map<String, String> settings = {"2": "/settings", "4": "/about"};
            setState(() {
              _selectedValue = value!;
              print("selected value $_selectedValue");
              if (_selectedValue == "2" || _selectedValue == "4") {
                Navigator.pushNamed(context, settings[_selectedValue]!);
              } else if (_selectedValue == "3") {
                alert("This feature is coming soon");
              }
              print(_selectedValue);
            });
          },
          itemBuilder: (context) => [
            menuItemWidget("Task List", "1", CupertinoIcons.list_bullet_indent),
            menuItemWidget("Settings ", "2", Icons.settings),
            // menuItemWidget("Sync List", "3", Icons.share),
            menuItemWidget("About", "4", CupertinoIcons.info_circle_fill),
          ],
        ),
      ],
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

  void alert(String msg) async {
    var title = await storage.read(key: "title");
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                title!,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              title: const Text("Time Management App"),
              actions: [
                TextButton(
                    onPressed: () async {
                      canShowReminder = true;
                      await NotificationController.player.stop();
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"))
              ],
              icon: const Icon(
                CupertinoIcons.alarm,
                size: 40,
                color: Colors.cyan,
              ),
            ));
  }

  void alert2(String msg) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                msg,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              title: const Text("Syncronize List"),
              actions: [
                TextButton(
                    onPressed: () async {
                      canShowReminder = true;
                      await NotificationController.player.stop();
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"))
              ],
              icon: const Icon(
                CupertinoIcons.alarm,
                size: 40,
                color: Colors.cyan,
              ),
            ));
  }

  PopupMenuItem<String> menuItemWidget(
      String label, String value, IconData ic) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            ic,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
