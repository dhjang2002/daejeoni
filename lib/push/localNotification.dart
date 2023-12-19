// ignore_for_file: non_constant_identifier_names, file_names, constant_identifier_names
import 'dart:convert';

import 'package:daejeoni/home/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final LocalNotification notification = LocalNotification();

const AndroidIcon = "ic_notification";
final FlutterLocalNotificationsPlugin
_flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class LocalNotification {
  late BuildContext _context;
  Future <void> init(BuildContext context) async {
    _context = context;
    await configureLocalTimeZone();
    await initializeNotification();
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future <void> initializeNotification() async {
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings(AndroidIcon);

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  //! Foreground 상태(앱이 열린 상태에서 받은 경우)
  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    if (kDebugMode) {
      print("onDidReceiveNotificationResponse:<><><><><><><><><><><><><><><><><><><><><><><><>>");
    }

    final String payload = notificationResponse.payload ?? "";
    if (notificationResponse.payload != null ||
        notificationResponse.payload!.isNotEmpty) {
        // final parsedJson = jsonDecode(payload);
        // if (kDebugMode) {
        //   var logger = Logger();
        //   logger.d(parsedJson);
        // }
        goPushHome(_context);
    }

  }

  //! Background 상태(앱이 닫힌 상태에서 받은 경우)
  static void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
    if (kDebugMode) {
      print("onBackgroundNotificationResponse:<><><><><><><><><><><><><><><<><><><><<><><><><><>");
    }
    final String payload = notificationResponse.payload ?? "";
    if (notificationResponse.payload != null ||
        notificationResponse.payload!.isNotEmpty) {
      final parsedJson = jsonDecode(payload);
      if (kDebugMode) {
        var logger = Logger();
        logger.d(parsedJson);
      }
    }
  }


  Future<void> cancel() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> requestPermissions() async {
    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation <
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true,);
  }

  Future <void> show({required String title, required String body, String? action=""}) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    NotificationDetails notificationDetails =
    const NotificationDetails(
      android: AndroidNotificationDetails(
        "easyapproach",
        "easyapproach channel",
        importance: Importance.max,
        priority: Priority.max,
        showWhen: false,
        // ongoing: true,
        // styleInformation: BigTextStyleInformation(message),
        icon: AndroidIcon,
      ),
      iOS: DarwinNotificationDetails(
        badgeNumber: 1,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: json.encode({"title":title, "body":body, "action":action})
    );
  }

  Future <void> showSchedule({
    required int hour,
    required int minutes,
    required message,
    required String title,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes,);
    await _flutterLocalNotificationsPlugin.zonedSchedule(0,
      title,
      message,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "easyapproach",
          "easyapproach channel",
          importance: Importance.max,
          priority: Priority.high,
          // ongoing: true,
          // styleInformation: BigTextStyleInformation(message),
          icon: AndroidIcon,
        ),
        iOS: DarwinNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      //androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

}


