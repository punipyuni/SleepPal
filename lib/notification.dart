import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    // Handle notification response here
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("mipmap/ic_launcher");

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Request notification permissions for Android 13+ using permission_handler
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Initialize timezone data
    tz.initializeTimeZones(); // Important step
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecific = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecific);
  }

  static Future<void> scheduleNotification(String title, String body, DateTime scheduledDate) async {
    const NotificationDetails platformChannelSpecific = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_Id",
        "channel_Name",
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    // Ensure that tz.local is available before use
    tz.TZDateTime scheduledTZDateTime;

    // If the scheduledDate is in the past, add one day to schedule it for the next day
    if (scheduledDate.isBefore(DateTime.now())) {
      scheduledTZDateTime = tz.TZDateTime.from(scheduledDate.add(Duration(days: 1)), tz.local);
    } else {
      scheduledTZDateTime = tz.TZDateTime.from(scheduledDate, tz.local);
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledTZDateTime,
      platformChannelSpecific,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }
}