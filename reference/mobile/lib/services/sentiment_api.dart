import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';
import '../models/prediction_result.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class SentimentApi {
  SentimentApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String baseUrl;

  Future<PredictionResult> predict({
    required String text,
    required int week,
    required bool includeExplanation,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/api/v1/predict'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'text': text,
              'week': week,
              'include_explanation': includeExplanation,
            }),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) {
        throw ApiException(
          'API mengembalikan status ${response.statusCode}: ${response.body}',
        );
      }
      return PredictionResult.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } on TimeoutException {
      throw const ApiException('Waktu tunggu API habis.');
    } on http.ClientException catch (error) {
      throw ApiException('API tidak dapat dihubungi: ${error.message}');
    }
  }

  Future<Map<String, dynamic>> fetchMetrics() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/api/v1/metrics'))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) {
        throw ApiException('Metrik gagal dimuat (${response.statusCode}).');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on TimeoutException {
      throw const ApiException('Waktu tunggu metrik habis.');
    } on http.ClientException catch (error) {
      throw ApiException('API tidak dapat dihubungi: ${error.message}');
    }
  }

  Future<void> resetMetrics() async {
    final response = await _client
        .post(Uri.parse('$baseUrl/api/v1/metrics/reset'))
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      throw ApiException('Metrik gagal direset (${response.statusCode}).');
    }
  }

  void close() => _client.close();
}

