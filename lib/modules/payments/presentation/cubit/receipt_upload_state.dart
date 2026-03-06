import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/payments/data/service/receipt_validation_service.dart';

enum ReceiptStep {
  idle,
  imageSelected,
  analyzing,
  uploading,
  confirmed,
  pendingReview,
  error,
}

class ReceiptUploadState extends Equatable {
  final StateStatus status;
  final ReceiptStep step;
  final File? selectedImage;
  final ReceiptValidationResult? validationResult;
  final Booking? confirmedBooking;
  final Booking? pendingReviewBooking;
  final String? errorMessage;

  const ReceiptUploadState({
    this.status = StateStatus.initial,
    this.step = ReceiptStep.idle,
    this.selectedImage,
    this.validationResult,
    this.confirmedBooking,
    this.pendingReviewBooking,
    this.errorMessage,
  });

  bool get isLoading => status == StateStatus.loading;
  bool get hasImage => selectedImage != null;

  ReceiptUploadState copyWith({
    StateStatus? status,
    ReceiptStep? step,
    File? selectedImage,
    ReceiptValidationResult? validationResult,
    Booking? confirmedBooking,
    Booking? pendingReviewBooking,
    String? errorMessage,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return ReceiptUploadState(
      status: status ?? this.status,
      step: step ?? this.step,
      selectedImage:
          clearImage ? null : (selectedImage ?? this.selectedImage),
      validationResult: validationResult ?? this.validationResult,
      confirmedBooking: confirmedBooking ?? this.confirmedBooking,
      pendingReviewBooking:
          pendingReviewBooking ?? this.pendingReviewBooking,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status, step, selectedImage, validationResult,
        confirmedBooking, pendingReviewBooking, errorMessage,
      ];
}
