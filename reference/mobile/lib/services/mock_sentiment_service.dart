import '../models/prediction_result.dart';

class MockSentimentService {
  static const _positive = {
    'baik',
    'bagus',
    'jelas',
    'cepat',
    'ramah',
    'nyaman',
    'mudah',
    'membantu',
    'puas',
    'menarik',
    'bermanfaat',
    'lancar',
  };
  static const _negative = {
    'buruk',
    'lambat',
    'sulit',
    'rusak',
    'panas',
    'terlambat',
    'kecewa',
    'membingungkan',
    'terputus',
    'rumit',
    'tidak',
  };

  Future<PredictionResult> predict(String text, int week) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final words = text
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9 ]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    final positive = words.where(_positive.contains).toList();
    final negative = words.where(_negative.contains).toList();
    final difference = positive.length - negative.length;
    final label = difference > 0
        ? 'positif'
        : difference < 0
            ? 'negatif'
            : 'netral';
    final matched = label == 'positif'
        ? positive
        : label == 'negatif'
            ? negative
            : <String>[];
    final score = matched.isEmpty ? 0.51 : (0.62 + matched.length * 0.08).clamp(0, 0.94);

    return PredictionResult(
      label: label,
      score: score.toDouble(),
      probabilities: {
        'positif': label == 'positif' ? score.toDouble() : (1 - score.toDouble()) / 2,
        'netral': label == 'netral' ? score.toDouble() : (1 - score.toDouble()) / 2,
        'negatif': label == 'negatif' ? score.toDouble() : (1 - score.toDouble()) / 2,
      },
      modelVersion: 'offline-rule-demo',
      latencyMs: 350,
      explanation: matched
          .take(5)
          .map((word) => ExplanationItem(term: word, contribution: 0.2))
          .toList(),
      capabilities: const ['offline_demo'],
      traceId: 'offline',
      source: 'offline_demo',
    );
  }
}

