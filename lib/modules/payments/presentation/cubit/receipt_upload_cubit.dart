import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/data/repository/booking_repository.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/payments/data/repository/payment_repository.dart';
import 'package:moto_slot/modules/payments/data/repository/receipt_validation_repository.dart';
import 'package:moto_slot/modules/payments/data/service/receipt_storage_service.dart';
import 'package:moto_slot/modules/payments/data/service/receipt_validation_service.dart';
import 'package:moto_slot/modules/payments/domain/model/receipt_validation.dart';
import 'package:moto_slot/modules/payments/presentation/cubit/receipt_upload_state.dart';

class ReceiptUploadCubit extends Cubit<ReceiptUploadState> {
  final PaymentRepository _paymentRepository;
  final ReceiptValidationRepository _receiptValidationRepository;
  final ReceiptValidationService _validationService;
  final ReceiptStorageService _storageService;
  final BookingRepository _bookingRepository;
  final ImagePicker _imagePicker;
  static const _uuid = Uuid();

  ReceiptUploadCubit({
    required PaymentRepository paymentRepository,
    required ReceiptValidationRepository receiptValidationRepository,
    required ReceiptValidationService validationService,
    required ReceiptStorageService storageService,
    required BookingRepository bookingRepository,
    ImagePicker? imagePicker,
  })  : _paymentRepository = paymentRepository,
        _receiptValidationRepository = receiptValidationRepository,
        _validationService = validationService,
        _storageService = storageService,
        _bookingRepository = bookingRepository,
        _imagePicker = imagePicker ?? ImagePicker(),
        super(const ReceiptUploadState());

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      emit(state.copyWith(
        selectedImage: File(pickedFile.path),
        step: ReceiptStep.imageSelected,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        step: ReceiptStep.error,
        errorMessage: 'failedToPickImage',
      ));
    }
  }

  Future<void> validateAndUploadReceipt({
    required Booking booking,
  }) async {
    if (state.selectedImage == null) return;

    emit(state.copyWith(
      status: StateStatus.loading,
      step: ReceiptStep.analyzing,
      clearError: true,
    ));

    try {
      // 1. Run on-device ML Kit text recognition + validation
      final result = await _validationService.validateReceipt(
        imageFile: state.selectedImage!,
        expectedAmount: booking.amount ?? 0,
        bookingDate: booking.createdAt,
        recipientKeywords: AppConstants.expectedRecipientKeywords,
      );

      emit(state.copyWith(
        step: ReceiptStep.uploading,
        validationResult: result,
      ));

      // 2. Upload image to Firebase Storage
      final imageUrl = await _storageService.uploadReceipt(
        imageFile: state.selectedImage!,
        bookingId: booking.id,
        userId: booking.userId,
      );

      // 3. Determine if auto-approved
      final isAutoApproved =
          result.confidenceScore >= AppConstants.receiptAutoConfirmThreshold;

      // 4. Save ReceiptValidation document
      final validationId = _uuid.v4();
      final validation = ReceiptValidation(
        id: validationId,
        bookingId: booking.id,
        paymentId: '', // updated after payment creation
        userId: booking.userId,
        receiptImageUrl: imageUrl,
        extractedText: result.extractedText,
        extractedAmount: result.extractedAmount,
        extractedDate: result.extractedDate,
        extractedRecipient: result.extractedRecipient,
        confidenceScore: result.confidenceScore,
        amountMatched: result.amountMatched,
        dateMatched: result.dateMatched,
        recipientMatched: result.recipientMatched,
        isAutoApproved: isAutoApproved,
        createdAt: DateTime.now().toUtc(),
      );
      await _receiptValidationRepository.saveValidation(validation);

      // 5. Create payment record
      final payment = await _paymentRepository.createReceiptPayment(
        bookingId: booking.id,
        userId: booking.userId,
        amount: booking.amount ?? 0,
        receiptImageUrl: imageUrl,
        receiptValidationId: validationId,
      );

      // Update validation with payment ID
      await _receiptValidationRepository.saveValidation(
        validation.copyWith(paymentId: payment.id),
      );

      // 6. Auto-confirm or queue for review
      if (isAutoApproved) {
        final confirmed = await _bookingRepository.confirmBooking(
          bookingId: booking.id,
          paymentId: payment.id,
          receiptValidationId: validationId,
        );
        emit(state.copyWith(
          status: StateStatus.success,
          step: ReceiptStep.confirmed,
          confirmedBooking: confirmed,
          validationResult: result,
        ));
      } else {
        final pendingBooking =
            await _bookingRepository.setBookingPendingReview(
          bookingId: booking.id,
          paymentId: payment.id,
          receiptValidationId: validationId,
          receiptImageUrl: imageUrl,
        );
        emit(state.copyWith(
          status: StateStatus.success,
          step: ReceiptStep.pendingReview,
          pendingReviewBooking: pendingBooking,
          validationResult: result,
        ));
      }
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        step: ReceiptStep.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        step: ReceiptStep.error,
        errorMessage: 'receiptValidationFailed',
      ));
    }
  }

  void clearState() {
    emit(const ReceiptUploadState());
  }
}
