import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:moto_slot/core/constants/app_constants.dart';

class ReceiptStorageService {
  final FirebaseStorage _storage;

  ReceiptStorageService({required FirebaseStorage storage})
      : _storage = storage;

  Future<String> uploadReceipt({
    required File imageFile,
    required String bookingId,
    required String userId,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage
        .ref()
        .child(AppConstants.receiptsStoragePath)
        .child(userId)
        .child('${bookingId}_$timestamp.jpg');

    final uploadTask = await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return await uploadTask.ref.getDownloadURL();
  }
}
