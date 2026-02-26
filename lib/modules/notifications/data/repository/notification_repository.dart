import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:moto_slot/core/constants/app_constants.dart';

class NotificationRepository {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _initialized = false;

  NotificationRepository()
      : _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(AppConstants.tbilisiTimezone));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - deep link to booking details
  }

  Future<bool> requestPermission() async {
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final ios = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  Future<void> scheduleBookingReminder({
    required int notificationId,
    required String bookingId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await initialize();

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return; // Don't schedule past notifications
    }

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'booking_reminders',
          'Booking Reminders',
          channelDescription: 'Reminders for upcoming motorcycle lessons',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: bookingId,
    );
  }

  Future<void> scheduleBookingReminders({
    required String bookingId,
    required DateTime lessonStartTime,
    required String location,
  }) async {
    // 24 hours before
    final reminder24h = lessonStartTime.subtract(const Duration(hours: 24));
    await scheduleBookingReminder(
      notificationId: bookingId.hashCode,
      bookingId: bookingId,
      title: 'Lesson Tomorrow',
      body: 'Your motorcycle lesson is tomorrow at '
          '${_formatTime(lessonStartTime)}. Location: $location',
      scheduledTime: reminder24h,
    );

    // 1 hour before
    final reminder1h = lessonStartTime.subtract(const Duration(hours: 1));
    await scheduleBookingReminder(
      notificationId: bookingId.hashCode + 1,
      bookingId: bookingId,
      title: 'Lesson in 1 Hour',
      body: 'Your motorcycle lesson starts in 1 hour at '
          '${_formatTime(lessonStartTime)}. Location: $location',
      scheduledTime: reminder1h,
    );
  }

  Future<void> cancelBookingReminders(String bookingId) async {
    await _notificationsPlugin.cancel(bookingId.hashCode);
    await _notificationsPlugin.cancel(bookingId.hashCode + 1);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  String _formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}
