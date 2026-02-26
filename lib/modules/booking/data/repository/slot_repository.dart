import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';

class SlotRepository {
  final FirebaseFirestore _firestore;

  SlotRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _slotsRef =>
      _firestore.collection(AppConstants.slotsCollection);

  Future<List<TimeSlot>> getAvailableSlots({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final snapshot = await _slotsRef
          .where('status', isEqualTo: SlotStatus.available.value)
          .where('startTime',
              isGreaterThanOrEqualTo: fromDate.toUtc().toIso8601String())
          .where('startTime',
              isLessThanOrEqualTo: toDate.toUtc().toIso8601String())
          .orderBy('startTime')
          .get();

      return snapshot.docs.map((doc) => TimeSlot.fromJson(doc.data())).toList();
    } catch (e) {
      throw BookingException(
        message: 'Failed to fetch available slots.',
        originalError: e,
      );
    }
  }

  Future<List<TimeSlot>> getAllSlots({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final snapshot = await _slotsRef
          .where('startTime',
              isGreaterThanOrEqualTo: fromDate.toUtc().toIso8601String())
          .where('startTime',
              isLessThanOrEqualTo: toDate.toUtc().toIso8601String())
          .orderBy('startTime')
          .get();

      return snapshot.docs.map((doc) => TimeSlot.fromJson(doc.data())).toList();
    } catch (e) {
      throw BookingException(
        message: 'Failed to fetch slots.',
        originalError: e,
      );
    }
  }

  Future<TimeSlot?> getSlotById(String slotId) async {
    final doc = await _slotsRef.doc(slotId).get();
    if (!doc.exists || doc.data() == null) return null;
    return TimeSlot.fromJson(doc.data()!);
  }

  Future<List<TimeSlot>> getSlotsForDay(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final snapshot = await _slotsRef
          .where('status', isEqualTo: SlotStatus.available.value)
          .where('startTime',
              isGreaterThanOrEqualTo: startOfDay.toUtc().toIso8601String())
          .where('startTime',
              isLessThan: endOfDay.toUtc().toIso8601String())
          .orderBy('startTime')
          .get();

      return snapshot.docs
          .map((doc) => TimeSlot.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw BookingException(
        message: 'Failed to fetch slots for day.',
        originalError: e,
      );
    }
  }

  Future<TimeSlot> lockSlot({
    required String slotId,
    required String userId,
    required Duration lockDuration,
  }) async {
    try {
      return await _firestore.runTransaction<TimeSlot>((transaction) async {
        final docRef = _slotsRef.doc(slotId);
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists || snapshot.data() == null) {
          throw const BookingException(message: 'Slot not found.');
        }

        final slot = TimeSlot.fromJson(snapshot.data()!);

        if (slot.status != SlotStatus.available) {
          // Check if lock is expired
          if (slot.status == SlotStatus.locked && slot.isLockExpired) {
            // Lock expired, can re-lock
          } else {
            throw const BookingException(
              message: 'This slot is no longer available.',
            );
          }
        }

        final lockExpiry = DateTime.now().toUtc().add(lockDuration);
        final updatedSlot = slot.copyWith(
          status: SlotStatus.locked,
          lockedByUserId: userId,
          lockExpiresAt: lockExpiry,
        );

        transaction.update(docRef, updatedSlot.toJson());
        return updatedSlot;
      });
    } catch (e) {
      if (e is BookingException) rethrow;
      throw BookingException(
        message: 'Failed to reserve slot. Please try again.',
        originalError: e,
      );
    }
  }

  Future<void> unlockSlot(String slotId) async {
    try {
      await _slotsRef.doc(slotId).update({
        'status': SlotStatus.available.value,
        'lockedByUserId': null,
        'lockExpiresAt': null,
      });
    } catch (e) {
      throw BookingException(
        message: 'Failed to release slot.',
        originalError: e,
      );
    }
  }

  Future<void> markSlotAsBooked({
    required String slotId,
    required String userId,
    required String bookingId,
  }) async {
    await _slotsRef.doc(slotId).update({
      'status': SlotStatus.booked.value,
      'bookedByUserId': userId,
      'bookingId': bookingId,
      'lockedByUserId': null,
      'lockExpiresAt': null,
    });
  }

  Future<void> releaseSlot(String slotId) async {
    await _slotsRef.doc(slotId).update({
      'status': SlotStatus.available.value,
      'bookedByUserId': null,
      'bookingId': null,
      'lockedByUserId': null,
      'lockExpiresAt': null,
    });
  }

  Future<void> createSlot(TimeSlot slot) async {
    await _slotsRef.doc(slot.id).set(slot.toJson());
  }

  Future<void> createSlots(List<TimeSlot> slots) async {
    final batch = _firestore.batch();
    for (final slot in slots) {
      batch.set(_slotsRef.doc(slot.id), slot.toJson());
    }
    await batch.commit();
  }

  Future<void> blockSlot(String slotId) async {
    await _slotsRef.doc(slotId).update({
      'status': SlotStatus.blocked.value,
    });
  }

  Future<void> deleteSlot(String slotId) async {
    await _slotsRef.doc(slotId).delete();
  }
}
