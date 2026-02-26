import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:uuid/uuid.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/admin/domain/model/availability_config.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';

class AdminRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final _uuid = const Uuid();

  AdminRepository({
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _functions = functions;

  // ── Availability Config ──

  Future<AvailabilityConfig?> getAvailabilityConfig() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.availabilityCollection)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return AvailabilityConfig.fromJson(snapshot.docs.first.data());
    } catch (e) {
      throw BookingException(
        message: 'Failed to load availability settings.',
        originalError: e,
      );
    }
  }

  Future<AvailabilityConfig> saveAvailabilityConfig(
    AvailabilityConfig config,
  ) async {
    try {
      await _firestore
          .collection(AppConstants.availabilityCollection)
          .doc(config.id)
          .set(config.toJson());
      return config;
    } catch (e) {
      throw BookingException(
        message: 'Failed to save availability settings.',
        originalError: e,
      );
    }
  }

  // ── Generate Slots ──

  Future<List<TimeSlot>> generateSlots({
    required AvailabilityConfig config,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final slots = <TimeSlot>[];
    var currentDate = fromDate;

    while (currentDate.isBefore(toDate) ||
        currentDate.isAtSameMomentAs(toDate)) {
      final weekday = currentDate.weekday;

      // Check if it's a working day
      if (config.workingDays.contains(weekday)) {
        // Check if it's not a blocked date
        final isBlocked = config.blockedDates.any(
          (d) =>
              d.year == currentDate.year &&
              d.month == currentDate.month &&
              d.day == currentDate.day,
        );

        if (!isBlocked) {
          final startParts = config.startTime.split(':');
          final endParts = config.endTime.split(':');

          var slotStart = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            int.parse(startParts[0]),
            int.parse(startParts[1]),
          ).toUtc();

          final dayEnd = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            int.parse(endParts[0]),
            int.parse(endParts[1]),
          ).toUtc();

          while (slotStart
              .add(Duration(minutes: config.lessonDurationMinutes))
              .isBefore(dayEnd) ||
              slotStart
                  .add(Duration(minutes: config.lessonDurationMinutes))
                  .isAtSameMomentAs(dayEnd)) {
            final slotEnd = slotStart
                .add(Duration(minutes: config.lessonDurationMinutes));

            // Only generate future slots
            if (slotStart.isAfter(DateTime.now().toUtc())) {
              slots.add(TimeSlot(
                id: _uuid.v4(),
                startTime: slotStart,
                endTime: slotEnd,
                durationMinutes: config.lessonDurationMinutes,
                status: SlotStatus.available,
                instructorName: config.instructorName,
                location: config.location,
                createdAt: DateTime.now().toUtc(),
              ));
            }

            slotStart = slotEnd
                .add(Duration(minutes: config.bufferMinutes));
          }
        }
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Batch write to Firestore
    if (slots.isNotEmpty) {
      final slotsRef =
          _firestore.collection(AppConstants.slotsCollection);
      final batch = _firestore.batch();
      for (final slot in slots) {
        batch.set(slotsRef.doc(slot.id), slot.toJson());
      }
      await batch.commit();
    }

    return slots;
  }

  // ── Block Dates ──

  Future<void> blockDate(DateTime date) async {
    final config = await getAvailabilityConfig();
    if (config == null) return;

    final updatedDates = [...config.blockedDates, date];
    await saveAvailabilityConfig(
      config.copyWith(blockedDates: updatedDates, updatedAt: DateTime.now().toUtc()),
    );

    // Also block any existing available slots on that date
    final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection(AppConstants.slotsCollection)
        .where('startTime',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('startTime', isLessThan: endOfDay.toIso8601String())
        .where('status', isEqualTo: SlotStatus.available.value)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'status': SlotStatus.blocked.value});
    }
    await batch.commit();
  }

  Future<void> unblockDate(DateTime date) async {
    final config = await getAvailabilityConfig();
    if (config == null) return;

    final updatedDates = config.blockedDates
        .where((d) =>
            !(d.year == date.year &&
                d.month == date.month &&
                d.day == date.day))
        .toList();

    await saveAvailabilityConfig(
      config.copyWith(blockedDates: updatedDates, updatedAt: DateTime.now().toUtc()),
    );
  }

  // ── Manual Booking ──

  Future<Booking> createManualBooking({
    required String slotId,
    required String userFullName,
    required String userPhone,
    required TimeSlot slot,
    String? instructorName,
    String? location,
    String? contactPhone,
  }) async {
    try {
      final bookingId = _uuid.v4();
      final guestId = 'guest_${_uuid.v4()}';
      final booking = Booking(
        id: bookingId,
        slotId: slotId,
        userId: guestId,
        userFullName: userFullName,
        userPhone: userPhone,
        userEmail: '',
        startTime: slot.startTime,
        endTime: slot.endTime,
        durationMinutes: slot.durationMinutes,
        status: BookingStatus.confirmed,
        instructorName: instructorName ?? slot.instructorName,
        location: location ?? slot.location,
        contactPhone: contactPhone,
        isManualBooking: true,
        createdAt: DateTime.now().toUtc(),
        confirmedAt: DateTime.now().toUtc(),
      );

      // Atomic: create booking + update slot
      final batch = _firestore.batch();
      batch.set(
        _firestore.collection(AppConstants.bookingsCollection).doc(bookingId),
        booking.toJson(),
      );
      batch.update(
        _firestore.collection(AppConstants.slotsCollection).doc(slotId),
        {
          'status': SlotStatus.booked.value,
          'bookedByUserId': guestId,
          'bookingId': bookingId,
        },
      );
      await batch.commit();

      // Send SMS via Cloud Function
      try {
        await _functions.httpsCallable('sendBookingSms').call({
          'phone': userPhone,
          'bookingRef': booking.bookingReference,
          'dateTime': slot.startTime.toIso8601String(),
          'location': location ?? slot.location ?? 'TBD',
          'instructorName': instructorName ?? slot.instructorName ?? '',
          'contactPhone': contactPhone ?? '',
        });
      } catch (_) {
        // SMS failure shouldn't block booking
      }

      return booking;
    } catch (e) {
      if (e is BookingException) rethrow;
      throw BookingException(
        message: 'Failed to create manual booking.',
        originalError: e,
      );
    }
  }

  // ── Admin Booking Management ──

  Future<List<Booking>> getFilteredBookings({
    BookingStatus? status,
    DateTime? date,
  }) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection(AppConstants.bookingsCollection);

    if (status != null) {
      query = query.where('status', isEqualTo: status.value);
    }

    if (date != null) {
      final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
      final endOfDay = startOfDay.add(const Duration(days: 1));
      query = query
          .where('startTime',
              isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('startTime', isLessThan: endOfDay.toIso8601String());
    }

    query = query.orderBy('startTime', descending: true);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList();
  }

  Future<void> cancelBooking(String bookingId, String slotId) async {
    final batch = _firestore.batch();
    batch.update(
      _firestore.collection(AppConstants.bookingsCollection).doc(bookingId),
      {
        'status': BookingStatus.cancelled.value,
        'cancelledAt': DateTime.now().toUtc().toIso8601String(),
      },
    );
    batch.update(
      _firestore.collection(AppConstants.slotsCollection).doc(slotId),
      {
        'status': SlotStatus.available.value,
        'bookedByUserId': null,
        'bookingId': null,
      },
    );
    await batch.commit();
  }

  Future<void> completeBooking(String bookingId) async {
    await _firestore
        .collection(AppConstants.bookingsCollection)
        .doc(bookingId)
        .update({
      'status': BookingStatus.completed.value,
      'completedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
