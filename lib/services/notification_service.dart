import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDoseNotifications(
      String reminderId, List<String> doseTimes) async {
    await cancelScheduledNotifications(reminderId);

    for (int i = 0; i < doseTimes.length; i++) {
      final timeParts = doseTimes[i].split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final scheduledDate = _nextInstanceOfTime(hour, minute);

      await _notificationsPlugin.zonedSchedule(
        _generateNotificationId(reminderId, i),
        'Medication Reminder',
        'Time to take your medication!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_channel',
            'Medication Reminders',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            sound: RawResourceAndroidNotificationSound('notification'), // Ensure 'notification.mp3' exists in res/raw/
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default', // Ensure proper sound configuration for iOS
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Ensures notifications are accurate even in Doze mode
        //uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'reminder_$reminderId',
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelScheduledNotifications(String reminderId) async {
    for (int i = 0; i < 10; i++) {
      await _notificationsPlugin.cancel(_generateNotificationId(reminderId, i));
    }
  }

  int _generateNotificationId(String reminderId, int index) {
    return int.parse('${reminderId.hashCode.abs()}${index.toString().padLeft(2, '0')}');
  }
}
