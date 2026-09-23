import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../controllers/analysis_controller.dart';
import '../models/demo_week.dart';
import '../models/prediction_result.dart';
import '../widgets/week_banner.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key, required this.week});

  final DemoWeek week;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late final TextEditingController _textController;
  late final AnalysisController _controller;

  static const _examples = [
    'Pelayanan akademik sangat membantu',
    'Internet kampus sering terputus',
    'Kuliah dimulai pukul delapan',
  ];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _examples.first);
    _controller = AnalysisController(week: widget.week.week);
  }

  @override
  void didUpdateWidget(covariant AnalysisPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.week.week != widget.week.week) {
      _controller.updateWeek(widget.week.week);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            WeekBanner(week: widget.week),
            const SizedBox(height: 16),
            Text('Laboratorium prediksi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            const Text(
              'Masukkan satu kalimat masukan mahasiswa. Jangan gunakan nama, NIM, atau data pribadi.',
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _textController,
              maxLength: 500,
              minLines: 3,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              onChanged: _controller.onTextChanged,
              decoration: const InputDecoration(
                labelText: 'Masukan mahasiswa',
                hintText: 'Contoh: Pelayanan laboratorium sangat membantu',
                prefixIcon: Icon(Icons.edit_note),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final example in _examples)
                  ActionChip(
                    label: Text(example),
                    onPressed: () {
                      _textController.text = example;
                      _controller.onTextChanged(example);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Analisis otomatis'),
              subtitle: Text(
                widget.week.week >= 12
                    ? 'Aktifkan untuk mendemonstrasikan debounce: prediksi dikirim 650 ms setelah mahasiswa berhenti mengetik.'
                    : 'Fitur Android ini digunakan mulai pertemuan 12 sebagai ekstensi multi-platform.',
              ),
              value: _controller.realtimeEnabled,
              onChanged: widget.week.week >= 12
                  ? (value) => _controller.setRealtime(value, _textController.text)
                  : null,
            ),
            const SizedBox(height: 8),
            Semantics(
              button: true,
              label: 'Analisis sentimen kalimat',
              child: FilledButton.icon(
                onPressed: _controller.isLoading
                    ? null
                    : () => _controller.analyze(_textController.text),
                icon: const Icon(Icons.auto_awesome),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  child: Text('Analisis Sentimen'),
                ),
              ),
            ),
            if (_controller.isLoading) ...[
              const SizedBox(height: 14),
              const LinearProgressIndicator(),
              const SizedBox(height: 6),
              const Text('Model sedang membaca pola kata…'),
            ],
            if (_controller.message != null) ...[
              const SizedBox(height: 14),
              _MessagePanel(
                text: _controller.message!,
                isWarning: _controller.result?.isOffline ?? false,
              ),
            ],
            if (_controller.result != null) ...[
              const SizedBox(height: 14),
              _ResultCard(
                result: _controller.result!,
                showExplanation: widget.week.week >= 7,
              ),
            ],
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_outlined, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Model ini hanya untuk belajar. Prediksi sentimen dapat salah karena bahasa manusia memiliki konteks, ironi, dan makna yang tidak selalu tampak dari kata-katanya.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MessagePanel extends StatelessWidget {
  const _MessagePanel({required this.text, required this.isWarning});

  final String text;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWarning ? colors.errorContainer : colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(isWarning ? Icons.cloud_off_outlined : Icons.cloud_done_outlined),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.showExplanation});

  final PredictionResult result;
  final bool showExplanation;

  Color _labelColor(BuildContext context) {
    return switch (result.label) {
      'positif' => const Color(0xFF087F5B),
      'negatif' => Theme.of(context).colorScheme.error,
      _ => const Color(0xFF9A6700),
    };
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = _labelColor(context);
    final maxContribution = result.explanation.fold<double>(
      0.01,
      (value, item) => math.max(value, item.contribution.abs()),
    );
    return Semantics(
      liveRegion: true,
      label: 'Hasil sentimen ${result.label}, keyakinan ${result.confidencePercent}',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: labelColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.analytics_outlined, color: labelColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('HASIL PREDIKSI', style: TextStyle(fontSize: 12)),
                        Text(
                          result.label.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: labelColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (result.isOffline) const Chip(label: Text('OFFLINE')),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: result.score, color: labelColor),
              const SizedBox(height: 6),
              Text('Tingkat keyakinan model: ${result.confidencePercent}'),
              if (result.probabilities.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text('Probabilitas kelas', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                for (final entry in result.probabilities.entries) ...[
                  Row(
                    children: [
                      SizedBox(width: 70, child: Text(entry.key)),
                      Expanded(child: LinearProgressIndicator(value: entry.value)),
                      const SizedBox(width: 8),
                      Text('${(entry.value * 100).toStringAsFixed(1)}%'),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('Model ${result.modelVersion}')),
                  Chip(label: Text('${result.latencyMs.toStringAsFixed(1)} ms')),
                  Chip(label: Text('Trace ${result.traceId.length > 8 ? result.traceId.substring(0, 8) : result.traceId}')),
                ],
              ),
              if (showExplanation) ...[
                const Divider(height: 30),
                Text('Mengapa hasil ini muncul?', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                const Text(
                  'Batang berikut menunjukkan kata atau frasa yang paling memengaruhi kelas terpilih. Ini penjelasan sederhana, bukan kebenaran mutlak.',
                ),
                const SizedBox(height: 12),
                if (result.explanation.isEmpty)
                  const Text('Tidak ada kata yang dikenali model pada kalimat ini.')
                else
                  for (final item in result.explanation) ...[
                    Row(
                      children: [
                        SizedBox(width: 105, child: Text(item.term, overflow: TextOverflow.ellipsis)),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: item.contribution.abs() / maxContribution,
                            color: item.contribution >= 0 ? labelColor : Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(item.contribution.toStringAsFixed(3)),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

