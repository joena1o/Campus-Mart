import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_local_notification'),
      iOS: DarwinInitializationSettings(), // Updated from IOSInitializationSettings
    );

    _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({required int id, required String title, required String body}) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel',
        'Main Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(), // Updated from IOSNotificationDetails
    );

    await _notificationsPlugin.show(id, title, body, notificationDetails);
  }

  static Future<void> requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showLocalNotification() {
    NotificationService.showNotification(
      id: 0,
      title: 'Test Notification',
      body: 'This is a test notification',
    );
  }

}
