import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';

class TimeSlot extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final SlotStatus status;
  final String? bookedByUserId;
  final String? bookingId;
  final String? lockedByUserId;
  final DateTime? lockExpiresAt;
  final String? instructorName;
  final String? location;
  final DateTime createdAt;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.status,
    this.bookedByUserId,
    this.bookingId,
    this.lockedByUserId,
    this.lockExpiresAt,
    this.instructorName,
    this.location,
    required this.createdAt,
  });

  bool get isAvailable => status == SlotStatus.available;
  bool get isBooked => status == SlotStatus.booked;
  bool get isLocked => status == SlotStatus.locked;
  bool get isBlocked => status == SlotStatus.blocked;

  bool get isLockExpired {
    if (lockExpiresAt == null) return false;
    return DateTime.now().toUtc().isAfter(lockExpiresAt!);
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      status: SlotStatus.fromValue(json['status'] as String),
      bookedByUserId: json['bookedByUserId'] as String?,
      bookingId: json['bookingId'] as String?,
      lockedByUserId: json['lockedByUserId'] as String?,
      lockExpiresAt: json['lockExpiresAt'] != null
          ? DateTime.parse(json['lockExpiresAt'] as String)
          : null,
      instructorName: json['instructorName'] as String?,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'status': status.value,
      'bookedByUserId': bookedByUserId,
      'bookingId': bookingId,
      'lockedByUserId': lockedByUserId,
      'lockExpiresAt': lockExpiresAt?.toIso8601String(),
      'instructorName': instructorName,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TimeSlot copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    SlotStatus? status,
    String? bookedByUserId,
    String? bookingId,
    String? lockedByUserId,
    DateTime? lockExpiresAt,
    String? instructorName,
    String? location,
    DateTime? createdAt,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      bookedByUserId: bookedByUserId ?? this.bookedByUserId,
      bookingId: bookingId ?? this.bookingId,
      lockedByUserId: lockedByUserId ?? this.lockedByUserId,
      lockExpiresAt: lockExpiresAt ?? this.lockExpiresAt,
      instructorName: instructorName ?? this.instructorName,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        startTime,
        endTime,
        durationMinutes,
        status,
        bookedByUserId,
        bookingId,
        lockedByUserId,
        lockExpiresAt,
        instructorName,
        location,
        createdAt,
      ];
}
