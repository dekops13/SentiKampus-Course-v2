import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/prediction_result.dart';
import '../services/mock_sentiment_service.dart';
import '../services/sentiment_api.dart';

class AnalysisController extends ChangeNotifier {
  AnalysisController({
    required int week,
    SentimentApi? api,
    MockSentimentService? offlineService,
  })  : _week = week,
        _api = api ?? SentimentApi(),
        _offlineService = offlineService ?? MockSentimentService();

  final SentimentApi _api;
  final MockSentimentService _offlineService;
  Timer? _debounce;
  int _week;

  bool isLoading = false;
  bool realtimeEnabled = false;
  String? message;
  PredictionResult? result;

  int get week => _week;

  void updateWeek(int value) {
    if (_week == value) return;
    _week = value;
    if (_week < 12) realtimeEnabled = false;
    notifyListeners();
  }

  void setRealtime(bool value, String currentText) {
    realtimeEnabled = value;
    notifyListeners();
    if (value) onTextChanged(currentText);
  }

  void onTextChanged(String text) {
    if (!realtimeEnabled || _week < 12) return;
    _debounce?.cancel();
    if (text.trim().length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 650), () => analyze(text));
  }

  Future<void> analyze(String text) async {
    final cleaned = text.trim();
    if (cleaned.length < 3) {
      message = 'Tuliskan sedikitnya tiga karakter sebelum melakukan analisis.';
      result = null;
      notifyListeners();
      return;
    }
    isLoading = true;
    message = null;
    notifyListeners();
    try {
      result = await _api.predict(
        text: cleaned,
        week: _week,
        includeExplanation: _week >= 7,
      );
      message = 'Prediksi diterima dari FastAPI.';
    } on ApiException catch (error) {
      result = await _offlineService.predict(cleaned, _week);
      message = '${error.message} Aplikasi beralih ke demo offline berbasis aturan.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _api.close();
    super.dispose();
  }
}

