import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz.initializeTimeZones();
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  const linux = LinuxInitializationSettings(defaultActionName: 'Open');
  await flnp.initialize(const InitializationSettings(android: android, iOS: ios, linux: linux));
}

Future<void> scheduleReminder(int taskId, String taskName, DateTime reminderAt) async {
  final scheduled = tz.TZDateTime.from(reminderAt, tz.local);
  if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

  await flnp.zonedSchedule(
    taskId,
    '🔔 Recordatorio',
    taskName,
    scheduled,
    const NotificationDetails(
      android: AndroidNotificationDetails('reminders', 'Recordatorios',
          importance: Importance.high, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> cancelReminder(int taskId) async {
  await flnp.cancel(taskId);
}
