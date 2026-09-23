import 'package:flutter_test/flutter_test.dart';
import 'package:sentikampus_mobile/models/prediction_result.dart';

void main() {
  test('PredictionResult membaca response API', () {
    final result = PredictionResult.fromJson({
      'label': 'positif',
      'score': 0.86,
      'probabilities': {'negatif': 0.05, 'netral': 0.09, 'positif': 0.86},
      'model_version': 'demo-1.0.0',
      'latency_ms': 12.5,
      'explanation': [
        {'term': 'membantu', 'contribution': 0.42},
      ],
      'capabilities': ['xai'],
      'trace_id': 'abc123',
      'source': 'api',
    });

    expect(result.label, 'positif');
    expect(result.confidencePercent, '86.0%');
    expect(result.probabilities['positif'], 0.86);
    expect(result.explanation.single.term, 'membantu');
    expect(result.isOffline, isFalse);
  });
}

