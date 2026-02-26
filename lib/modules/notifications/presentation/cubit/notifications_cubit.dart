import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/notifications/data/repository/notification_repository.dart';
import 'package:moto_slot/modules/notifications/presentation/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _notificationRepository;

  NotificationsCubit({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const NotificationsState());

  Future<void> initialize() async {
    try {
      await _notificationRepository.initialize();
      final granted = await _notificationRepository.requestPermission();
      emit(state.copyWith(
        status: StateStatus.success,
        permissionGranted: granted,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'Failed to initialize notifications.',
      ));
    }
  }

  Future<void> scheduleReminders({
    required String bookingId,
    required DateTime lessonStartTime,
    required String location,
  }) async {
    try {
      await _notificationRepository.scheduleBookingReminders(
        bookingId: bookingId,
        lessonStartTime: lessonStartTime,
        location: location,
      );
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to schedule reminder.',
      ));
    }
  }

  Future<void> cancelReminders(String bookingId) async {
    await _notificationRepository.cancelBookingReminders(bookingId);
  }

  Future<void> cancelAll() async {
    await _notificationRepository.cancelAllNotifications();
  }
}
