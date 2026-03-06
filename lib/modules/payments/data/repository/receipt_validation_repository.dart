import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/modules/payments/domain/model/receipt_validation.dart';

class ReceiptValidationRepository {
  final FirebaseFirestore _firestore;

  ReceiptValidationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _validationsRef =>
      _firestore.collection(AppConstants.receiptsCollection);

  Future<ReceiptValidation> saveValidation(
      ReceiptValidation validation) async {
    try {
      await _validationsRef.doc(validation.id).set(validation.toJson());
      return validation;
    } catch (e) {
      throw ReceiptValidationException(
        message: 'Failed to save receipt validation.',
        originalError: e,
      );
    }
  }

  Future<ReceiptValidation?> getValidationById(String id) async {
    final doc = await _validationsRef.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return ReceiptValidation.fromJson(doc.data()!);
  }

  Future<ReceiptValidation?> getValidationByBookingId(
      String bookingId) async {
    final snapshot = await _validationsRef
        .where('bookingId', isEqualTo: bookingId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return ReceiptValidation.fromJson(snapshot.docs.first.data());
  }

  Future<List<ReceiptValidation>> getPendingReviewValidations() async {
    final snapshot = await _validationsRef
        .where('isAutoApproved', isEqualTo: false)
        .where('isAdminApproved', isNull: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((d) => ReceiptValidation.fromJson(d.data()))
        .toList();
  }

  Future<void> approveValidation(String id, {String? note}) async {
    await _validationsRef.doc(id).update({
      'isAdminApproved': true,
      'adminNote': note,
      'reviewedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> rejectValidation(String id, {required String reason}) async {
    await _validationsRef.doc(id).update({
      'isAdminApproved': false,
      'rejectionReason': reason,
      'reviewedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
