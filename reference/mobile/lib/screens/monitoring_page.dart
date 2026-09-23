import 'package:flutter/material.dart';

import '../core/config/api_config.dart';
import '../models/demo_week.dart';
import '../services/sentiment_api.dart';
import '../widgets/week_banner.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key, required this.week});

  final DemoWeek week;

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  late final SentimentApi _api;
  Future<Map<String, dynamic>>? _metrics;

  @override
  void initState() {
    super.initState();
    _api = SentimentApi();
    if (widget.week.week >= 7) _refresh();
  }

  @override
  void didUpdateWidget(covariant MonitoringPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.week.week != widget.week.week && widget.week.week >= 7) {
      _refresh();
    }
  }

  void _refresh() {
    setState(() => _metrics = _api.fetchMetrics());
  }

  Future<void> _reset() async {
    try {
      await _api.resetMetrics();
      _refresh();
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  void dispose() {
    _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.week.week < 7) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          WeekBanner(week: widget.week),
          const SizedBox(height: 16),
          const _LockedMonitoring(),
        ],
      );
    }
    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          WeekBanner(week: widget.week),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monitoring API', style: Theme.of(context).textTheme.titleLarge),
                    Text(ApiConfig.baseUrl, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              IconButton(onPressed: _refresh, tooltip: 'Muat ulang', icon: const Icon(Icons.refresh)),
              IconButton(onPressed: _reset, tooltip: 'Reset metrik', icon: const Icon(Icons.delete_sweep_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<Map<String, dynamic>>(
            future: _metrics,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return _MonitoringError(error: snapshot.error.toString(), onRetry: _refresh);
              }
              final data = snapshot.data;
              if (data == null) return const Text('Belum ada data monitoring.');
              return _MetricsContent(data: data);
            },
          ),
        ],
      ),
    );
  }
}

class _LockedMonitoring extends StatelessWidget {
  const _LockedMonitoring();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.lock_clock_outlined, size: 54, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text('Monitoring dibuka pada pertemuan 7', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            const Text(
              'Kita membangun alur utama terlebih dahulu. Setelah aplikasi dapat memprediksi, barulah kita mengukur apakah layanan sehat, cepat, dan dapat dijelaskan.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsContent extends StatelessWidget {
  const _MetricsContent({required this.data});

  final Map<String, dynamic> data;

  double _number(Object? value) => (value as num? ?? 0).toDouble();

  @override
  Widget build(BuildContext context) {
    final latency = data['latency_ms'] as Map<String, dynamic>? ?? const {};
    final labels = data['label_distribution'] as Map<String, dynamic>? ?? const {};
    final total = _number(data['total_requests']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MetricTile(label: 'Total request', value: total.toInt().toString(), icon: Icons.sync_alt),
            _MetricTile(label: 'P50', value: '${_number(latency['p50']).toStringAsFixed(1)} ms', icon: Icons.speed),
            _MetricTile(label: 'P95', value: '${_number(latency['p95']).toStringAsFixed(1)} ms', icon: Icons.timer_outlined),
            _MetricTile(label: 'Error rate', value: '${(_number(data['error_rate']) * 100).toStringAsFixed(1)}%', icon: Icons.warning_amber),
          ],
        ),
        const SizedBox(height: 18),
        Text('Distribusi hasil', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (labels.isEmpty)
          const Text('Belum ada prediksi. Buka tab Analisis dan kirim beberapa kalimat.')
        else
          for (final entry in labels.entries) ...[
            Row(
              children: [
                SizedBox(width: 75, child: Text(entry.key)),
                Expanded(
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : _number(entry.value) / total,
                  ),
                ),
                const SizedBox(width: 10),
                Text('${entry.value}'),
              ],
            ),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'P50 berarti separuh request selesai lebih cepat dari angka tersebut. P95 menunjukkan batas waktu untuk sekitar 95% request dan membantu menemukan pengalaman pengguna yang lambat.',
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonitoringError extends StatelessWidget {
  const _MonitoringError({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined, size: 42),
            const SizedBox(height: 8),
            const Text('Metrik belum dapat diambil.', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}

