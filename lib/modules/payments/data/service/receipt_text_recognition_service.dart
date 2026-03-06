import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptTextRecognitionService {
  TextRecognizer? _textRecognizer;

  TextRecognizer get _recognizer {
    _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
    return _textRecognizer!;
  }

  Future<RecognizedText> recognizeText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    return await _recognizer.processImage(inputImage);
  }

  void dispose() {
    _textRecognizer?.close();
    _textRecognizer = null;
  }
}
