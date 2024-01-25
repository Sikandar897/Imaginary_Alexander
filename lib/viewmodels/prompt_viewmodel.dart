import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../repositories/prompt_repository.dart';

class PromptViewModel extends ChangeNotifier {
  late Uint8List _imageBytes = Uint8List(0);
  bool _isLoading = false;

  Uint8List get imageBytes => _imageBytes;
  bool get isLoading => _isLoading;

  Future<void> generateImage(String prompt) async {
    try {
      _isLoading = true;
      notifyListeners();

      final bytes = await PromptRepo.generateImage(prompt);
      if (bytes != null) {
        _imageBytes = bytes;
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
