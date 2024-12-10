import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization (you can uncomment if needed)
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //       requestAlertPermission: false,
    //       requestBadgePermission: false,
    //       requestSoundPermission: false,
    //     );

    final InitializationSettings initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    // Initialize the notification plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body, DateTime dateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local).add(const Duration(seconds: 1)), // Schedule notification 1 second after the provided time
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: 'HRS',
          importance: Importance.max,
          priority: Priority.max,
        ),
        // iOS details (you can uncomment if needed)
        // iOS: IOSNotificationDetails(
        //   sound: 'default.wav',
        //   presentAlert: true,
        //   presentBadge: true,
        //   presentSound: true,
        // ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact, // Add this line
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
