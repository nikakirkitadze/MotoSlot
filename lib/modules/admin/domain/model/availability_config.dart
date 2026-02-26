import 'package:equatable/equatable.dart';

class AvailabilityConfig extends Equatable {
  final String id;
  final List<int> workingDays; // 1=Monday ... 7=Sunday
  final String startTime; // "09:00"
  final String endTime; // "18:00"
  final int lessonDurationMinutes;
  final int bufferMinutes;
  final List<DateTime> blockedDates;
  final String? instructorName;
  final String? location;
  final String? contactPhone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AvailabilityConfig({
    required this.id,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
    required this.lessonDurationMinutes,
    required this.bufferMinutes,
    this.blockedDates = const [],
    this.instructorName,
    this.location,
    this.contactPhone,
    required this.createdAt,
    this.updatedAt,
  });

  factory AvailabilityConfig.fromJson(Map<String, dynamic> json) {
    return AvailabilityConfig(
      id: json['id'] as String,
      workingDays: List<int>.from(json['workingDays'] as List),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      lessonDurationMinutes: json['lessonDurationMinutes'] as int,
      bufferMinutes: json['bufferMinutes'] as int,
      blockedDates: (json['blockedDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      instructorName: json['instructorName'] as String?,
      location: json['location'] as String?,
      contactPhone: json['contactPhone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workingDays': workingDays,
      'startTime': startTime,
      'endTime': endTime,
      'lessonDurationMinutes': lessonDurationMinutes,
      'bufferMinutes': bufferMinutes,
      'blockedDates':
          blockedDates.map((e) => e.toIso8601String()).toList(),
      'instructorName': instructorName,
      'location': location,
      'contactPhone': contactPhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  AvailabilityConfig copyWith({
    String? id,
    List<int>? workingDays,
    String? startTime,
    String? endTime,
    int? lessonDurationMinutes,
    int? bufferMinutes,
    List<DateTime>? blockedDates,
    String? instructorName,
    String? location,
    String? contactPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AvailabilityConfig(
      id: id ?? this.id,
      workingDays: workingDays ?? this.workingDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      lessonDurationMinutes:
          lessonDurationMinutes ?? this.lessonDurationMinutes,
      bufferMinutes: bufferMinutes ?? this.bufferMinutes,
      blockedDates: blockedDates ?? this.blockedDates,
      instructorName: instructorName ?? this.instructorName,
      location: location ?? this.location,
      contactPhone: contactPhone ?? this.contactPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, workingDays, startTime, endTime, lessonDurationMinutes,
        bufferMinutes, blockedDates, instructorName, location, contactPhone,
        createdAt, updatedAt,
      ];
}
