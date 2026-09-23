class ExplanationItem {
  const ExplanationItem({required this.term, required this.contribution});

  factory ExplanationItem.fromJson(Map<String, dynamic> json) {
    return ExplanationItem(
      term: json['term'] as String? ?? '-',
      contribution: (json['contribution'] as num? ?? 0).toDouble(),
    );
  }

  final String term;
  final double contribution;
}

class PredictionResult {
  const PredictionResult({
    required this.label,
    required this.score,
    required this.probabilities,
    required this.modelVersion,
    required this.latencyMs,
    required this.explanation,
    required this.capabilities,
    required this.traceId,
    required this.source,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final rawExplanation = json['explanation'] as List<dynamic>? ?? const [];
    return PredictionResult(
      label: json['label'] as String? ?? 'tidak diketahui',
      score: (json['score'] as num? ?? 0).toDouble(),
      probabilities: (json['probabilities'] as Map<String, dynamic>? ?? const {})
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      modelVersion: json['model_version'] as String? ?? 'unknown',
      latencyMs: (json['latency_ms'] as num? ?? 0).toDouble(),
      explanation: rawExplanation
          .map((item) => ExplanationItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      capabilities: (json['capabilities'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      traceId: json['trace_id'] as String? ?? '-',
      source: json['source'] as String? ?? 'api',
    );
  }

  final String label;
  final double score;
  final Map<String, double> probabilities;
  final String modelVersion;
  final double latencyMs;
  final List<ExplanationItem> explanation;
  final List<String> capabilities;
  final String traceId;
  final String source;

  String get confidencePercent => '${(score * 100).toStringAsFixed(1)}%';
  bool get isOffline => source == 'offline_demo';
}

