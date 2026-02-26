import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';

class NotificationsState extends Equatable {
  final StateStatus status;
  final bool permissionGranted;
  final String? errorMessage;

  const NotificationsState({
    this.status = StateStatus.initial,
    this.permissionGranted = false,
    this.errorMessage,
  });

  NotificationsState copyWith({
    StateStatus? status,
    bool? permissionGranted,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, permissionGranted, errorMessage];
}
