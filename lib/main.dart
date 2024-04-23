import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:time_management_app/screens/about.dart';
import 'package:time_management_app/screens/reminder.dart';
import 'package:time_management_app/screens/settings.dart';
// import 'package:time_management_app/screens/home.dart';
import 'package:time_management_app/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      // 'resource://drawable/res_app_icon',
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.blue,
            importance: NotificationImportance.High,
            criticalAlerts: true,
            channelShowBadge: true,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimeManagementApp',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/reminder': (context) => const ReminderScreen(),
        '/settings': (context) => const SettingsScreen(),
        "/about": (context) => const AboutScreen()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
    );
  }
}
