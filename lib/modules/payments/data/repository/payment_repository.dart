import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/payments/domain/model/payment.dart';

class PaymentRepository {
  final FirebaseFunctions _functions;
  final FirebaseFirestore _firestore;

  PaymentRepository({
    required FirebaseFunctions functions,
    required FirebaseFirestore firestore,
  })  : _functions = functions,
        _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _paymentsRef =>
      _firestore.collection(AppConstants.paymentsCollection);

  /// Creates a payment intent on the backend and returns payment with URL
  Future<Payment> createPaymentIntent({
    required String bookingId,
    required String userId,
    required double amount,
    required PaymentProvider provider,
  }) async {
    try {
      final result = await _functions
          .httpsCallable('createPaymentIntent')
          .call({
        'bookingId': bookingId,
        'userId': userId,
        'amount': amount,
        'currency': 'GEL',
        'provider': provider.value,
        'callbackUrl': 'motoslot://payment-result',
      });

      return Payment.fromJson(
        Map<String, dynamic>.from(result.data as Map),
      );
    } catch (e) {
      throw PaymentException(
        message: 'Failed to initiate payment. Please try again.',
        originalError: e,
      );
    }
  }

  /// Verifies payment status with the backend
  Future<Payment> verifyPayment({
    required String paymentId,
    required String transactionId,
  }) async {
    try {
      final result = await _functions
          .httpsCallable('verifyPayment')
          .call({
        'paymentId': paymentId,
        'transactionId': transactionId,
      });

      return Payment.fromJson(
        Map<String, dynamic>.from(result.data as Map),
      );
    } catch (e) {
      throw PaymentException(
        message: 'Failed to verify payment.',
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
    String? transactionId,
    String? errorMessage,
  }) async {
    final updates = <String, dynamic>{
      'status': status.value,
    };

    if (transactionId != null) {
      updates['transactionId'] = transactionId;
    }
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
