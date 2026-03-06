import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/payments/domain/model/payment.dart';

class PaymentRepository {
  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();

  PaymentRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _paymentsRef =>
      _firestore.collection(AppConstants.paymentsCollection);

  Future<Payment> createReceiptPayment({
    required String bookingId,
    required String userId,
    required double amount,
    required String receiptImageUrl,
    required String receiptValidationId,
  }) async {
    try {
      final paymentId = _uuid.v4();
      final payment = Payment(
        id: paymentId,
        bookingId: bookingId,
        userId: userId,
        amount: amount,
        currency: 'GEL',
        status: PaymentStatus.receiptUploaded,
        provider: PaymentProvider.receipt,
        receiptImageUrl: receiptImageUrl,
        receiptValidationId: receiptValidationId,
        createdAt: DateTime.now().toUtc(),
      );
      await _paymentsRef.doc(paymentId).set(payment.toJson());
      return payment;
    } catch (e) {
      throw PaymentException(
        message: 'Failed to create receipt payment.',
        originalError: e,
      );
    }
  }

  Future<Payment?> getPaymentById(String paymentId) async {
    final doc = await _paymentsRef.doc(paymentId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Payment.fromJson(doc.data()!);
  }

  Future<Payment?> getPaymentByBookingId(String bookingId) async {
    final snapshot = await _paymentsRef
        .where('bookingId', isEqualTo: bookingId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Payment.fromJson(snapshot.docs.first.data());
  }

  Future<void> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus status,
    String? errorMessage,
  }) async {
    final updates = <String, dynamic>{
      'status': status.value,
    };

    if (errorMessage != null) {
      updates['errorMessage'] = errorMessage;
    }
    if (status == PaymentStatus.success) {
      updates['completedAt'] = DateTime.now().toUtc().toIso8601String();
    }

    await _paymentsRef.doc(paymentId).update(updates);
  }

  Future<void> savePayment(Payment payment) async {
    await _paymentsRef.doc(payment.id).set(payment.toJson());
  }
}
