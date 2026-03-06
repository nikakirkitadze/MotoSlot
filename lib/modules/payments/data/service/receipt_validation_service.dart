import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/modules/payments/data/service/receipt_text_recognition_service.dart';

class ReceiptValidationResult extends Equatable {
  final String extractedText;
  final double? extractedAmount;
  final DateTime? extractedDate;
  final String? extractedRecipient;
  final bool amountMatched;
  final bool dateMatched;
  final bool recipientMatched;
  final double confidenceScore;

  const ReceiptValidationResult({
    required this.extractedText,
    this.extractedAmount,
    this.extractedDate,
    this.extractedRecipient,
    required this.amountMatched,
    required this.dateMatched,
    required this.recipientMatched,
    required this.confidenceScore,
  });

  @override
  List<Object?> get props => [
        extractedText, extractedAmount, extractedDate, extractedRecipient,
        amountMatched, dateMatched, recipientMatched, confidenceScore,
      ];
}

class ReceiptValidationService {
  final ReceiptTextRecognitionService _textRecognitionService;

  ReceiptValidationService({
    required ReceiptTextRecognitionService textRecognitionService,
  }) : _textRecognitionService = textRecognitionService;

  Future<ReceiptValidationResult> validateReceipt({
    required File imageFile,
    required double expectedAmount,
    required DateTime bookingDate,
    required List<String> recipientKeywords,
  }) async {
    final recognizedText =
        await _textRecognitionService.recognizeText(imageFile);
    final fullText = recognizedText.text;

    final extractedAmount = _extractAmount(fullText);
    final amountMatched = _checkAmountMatch(extractedAmount, expectedAmount);

    final extractedDate = _extractDate(fullText);
    final dateMatched = _checkDateMatch(extractedDate);

    final extractedRecipient =
        _extractRecipient(fullText, recipientKeywords);
    final recipientMatched = extractedRecipient != null;

    final confidenceScore = _calculateConfidence(
      amountMatched: amountMatched,
      dateMatched: dateMatched,
      recipientMatched: recipientMatched,
      hasText: fullText.trim().isNotEmpty,
    );

    return ReceiptValidationResult(
      extractedText: fullText,
      extractedAmount: extractedAmount,
      extractedDate: extractedDate,
      extractedRecipient: extractedRecipient,
      amountMatched: amountMatched,
      dateMatched: dateMatched,
      recipientMatched: recipientMatched,
      confidenceScore: confidenceScore,
    );
  }

  double? _extractAmount(String text) {
    // Match patterns like: 50.00, 50,00, 50.00 GEL, 50 ₾, 50.00₾, 50 ლარი
    final amountPatterns = [
      RegExp(r'(\d+[.,]\d{2})\s*(?:GEL|₾|ლარი)', caseSensitive: false),
      RegExp(r'(?:GEL|₾|ლარი)\s*(\d+[.,]\d{2})', caseSensitive: false),
      RegExp(
          r'(?:amount|თანხა|sum|total|ჯამი)[:\s]*(\d+[.,]\d{2})',
          caseSensitive: false),
      RegExp(r'(\d+[.,]\d{2})'),
    ];

    for (final pattern in amountPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final amountStr = match.group(1)!.replaceAll(',', '.');
        final amount = double.tryParse(amountStr);
        if (amount != null && amount > 0) {
          return amount;
        }
      }
    }

    return null;
  }

  bool _checkAmountMatch(double? extracted, double expected) {
    if (extracted == null) return false;
    return (extracted - expected).abs() < 0.01;
  }

  DateTime? _extractDate(String text) {
    final datePatterns = [
      // DD/MM/YYYY or DD.MM.YYYY
      RegExp(r'(\d{2})[./](\d{2})[./](\d{4})'),
      // YYYY-MM-DD
      RegExp(r'(\d{4})-(\d{2})-(\d{2})'),
      // DD-MM-YYYY
      RegExp(r'(\d{2})-(\d{2})-(\d{4})'),
    ];

    for (final pattern in datePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final groups = match.groups(
              List.generate(match.groupCount, (i) => i + 1));
          if (groups.length == 3) {
            int year, month, day;
            if (groups[0]!.length == 4) {
              // YYYY-MM-DD
              year = int.parse(groups[0]!);
              month = int.parse(groups[1]!);
              day = int.parse(groups[2]!);
            } else if (groups[2]!.length == 4) {
              // DD/MM/YYYY or DD-MM-YYYY
              day = int.parse(groups[0]!);
              month = int.parse(groups[1]!);
              year = int.parse(groups[2]!);
            } else {
              continue;
            }
            final date = DateTime(year, month, day);
            if (date.year > 2020 && date.year < 2100) {
              return date;
            }
          }
        } catch (_) {
          continue;
        }
      }
    }

    return null;
  }

  bool _checkDateMatch(DateTime? extractedDate) {
    if (extractedDate == null) return false;
    final now = DateTime.now();
    final difference = now.difference(extractedDate).inDays.abs();
    return difference <= AppConstants.receiptMaxAgeDays;
  }

  String? _extractRecipient(String text, List<String> keywords) {
    final lowerText = text.toLowerCase();
    for (final keyword in keywords) {
      if (lowerText.contains(keyword.toLowerCase())) {
        return keyword;
      }
    }
    return null;
  }

  double _calculateConfidence({
    required bool amountMatched,
    required bool dateMatched,
    required bool recipientMatched,
    required bool hasText,
  }) {
    double score = 0.0;
    if (amountMatched) score += 0.50;
    if (dateMatched) score += 0.25;
    if (recipientMatched) score += 0.20;
    if (hasText) score += 0.05;
    return score;
  }
}
