import 'package:equatable/equatable.dart';

class ReceiptValidation extends Equatable {
  final String id;
  final String bookingId;
  final String paymentId;
  final String userId;
  final String receiptImageUrl;
  final String? extractedText;
  final double? extractedAmount;
  final DateTime? extractedDate;
  final String? extractedRecipient;
  final double confidenceScore;
  final bool amountMatched;
  final bool dateMatched;
  final bool recipientMatched;
  final bool isAutoApproved;
  final bool? isAdminApproved;
  final String? adminNote;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  const ReceiptValidation({
    required this.id,
    required this.bookingId,
    required this.paymentId,
    required this.userId,
    required this.receiptImageUrl,
    this.extractedText,
    this.extractedAmount,
    this.extractedDate,
    this.extractedRecipient,
    required this.confidenceScore,
    required this.amountMatched,
    required this.dateMatched,
    required this.recipientMatched,
    required this.isAutoApproved,
    this.isAdminApproved,
    this.adminNote,
    this.rejectionReason,
    required this.createdAt,
    this.reviewedAt,
  });

  factory ReceiptValidation.fromJson(Map<String, dynamic> json) {
    return ReceiptValidation(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      paymentId: json['paymentId'] as String,
      userId: json['userId'] as String,
      receiptImageUrl: json['receiptImageUrl'] as String,
      extractedText: json['extractedText'] as String?,
      extractedAmount: (json['extractedAmount'] as num?)?.toDouble(),
      extractedDate: json['extractedDate'] != null
          ? DateTime.parse(json['extractedDate'] as String)
          : null,
      extractedRecipient: json['extractedRecipient'] as String?,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      amountMatched: json['amountMatched'] as bool,
      dateMatched: json['dateMatched'] as bool,
      recipientMatched: json['recipientMatched'] as bool,
      isAutoApproved: json['isAutoApproved'] as bool,
      isAdminApproved: json['isAdminApproved'] as bool?,
      adminNote: json['adminNote'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'paymentId': paymentId,
      'userId': userId,
      'receiptImageUrl': receiptImageUrl,
      'extractedText': extractedText,
      'extractedAmount': extractedAmount,
      'extractedDate': extractedDate?.toIso8601String(),
      'extractedRecipient': extractedRecipient,
      'confidenceScore': confidenceScore,
      'amountMatched': amountMatched,
      'dateMatched': dateMatched,
      'recipientMatched': recipientMatched,
      'isAutoApproved': isAutoApproved,
      'isAdminApproved': isAdminApproved,
      'adminNote': adminNote,
      'rejectionReason': rejectionReason,
      'createdAt': createdAt.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
    };
  }

  ReceiptValidation copyWith({
    String? id,
    String? bookingId,
    String? paymentId,
    String? userId,
    String? receiptImageUrl,
    String? extractedText,
    double? extractedAmount,
    DateTime? extractedDate,
    String? extractedRecipient,
    double? confidenceScore,
    bool? amountMatched,
    bool? dateMatched,
    bool? recipientMatched,
    bool? isAutoApproved,
    bool? isAdminApproved,
    String? adminNote,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? reviewedAt,
  }) {
    return ReceiptValidation(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      paymentId: paymentId ?? this.paymentId,
      userId: userId ?? this.userId,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      extractedText: extractedText ?? this.extractedText,
      extractedAmount: extractedAmount ?? this.extractedAmount,
      extractedDate: extractedDate ?? this.extractedDate,
      extractedRecipient: extractedRecipient ?? this.extractedRecipient,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      amountMatched: amountMatched ?? this.amountMatched,
      dateMatched: dateMatched ?? this.dateMatched,
      recipientMatched: recipientMatched ?? this.recipientMatched,
      isAutoApproved: isAutoApproved ?? this.isAutoApproved,
      isAdminApproved: isAdminApproved ?? this.isAdminApproved,
      adminNote: adminNote ?? this.adminNote,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, bookingId, paymentId, userId, receiptImageUrl,
        extractedText, extractedAmount, extractedDate, extractedRecipient,
        confidenceScore, amountMatched, dateMatched, recipientMatched,
        isAutoApproved, isAdminApproved, adminNote, rejectionReason,
        createdAt, reviewedAt,
      ];
}
