import 'package:flutter/material.dart';

import '../models/demo_week.dart';
import '../widgets/week_banner.dart';

class ArchitecturePage extends StatelessWidget {
  const ArchitecturePage({super.key, required this.week});

  final DemoWeek week;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        WeekBanner(week: week),
        const SizedBox(height: 16),
        Text('Aliran data SentiKampus', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        const Text(
          'Ikuti arah panah dari atas ke bawah. Setiap kotak memiliki satu tanggung jawab agar sistem mudah diuji dan diperbaiki.',
        ),
        const SizedBox(height: 16),
        _ArchitectureNode(
          icon: Icons.phone_android,
          title: '1. Frontend (Streamlit / Flutter)',
          subtitle: 'Streamlit dipakai lebih awal; Flutter Android menjadi ekstensi multi-platform.',
          active: week.has('streamlit_ui') || week.has('flutter_ui') || week.has('visualization'),
        ),
        const _FlowArrow(label: 'HTTP + JSON'),
        _ArchitectureNode(
          icon: Icons.api,
          title: '2. FastAPI',
          subtitle: 'Memvalidasi request, memanggil model, dan membentuk response.',
          active: week.has('api'),
        ),
        const _FlowArrow(label: 'Teks tervalidasi'),
        _ArchitectureNode(
          icon: Icons.model_training,
          title: '3. Model Sentimen',
          subtitle: 'TF-IDF mengubah kata menjadi angka; Logistic Regression memilih kelas.',
          active: week.has('model') || week.has('serialization'),
        ),
        const _FlowArrow(label: 'Label + probabilitas'),
        _ArchitectureNode(
          icon: Icons.monitor_heart_outlined,
          title: '4. Monitoring dan XAI',
          subtitle: 'Menyimpan latensi, error, distribusi label, dan kontribusi kata.',
          active: week.has('monitoring') || week.has('xai'),
        ),
        const SizedBox(height: 18),
        Text('Peta komponen ke file', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const _FileRow(component: 'Antarmuka', path: 'mobile/lib/screens/analysis_page.dart'),
        const _FileRow(component: 'Pemanggilan API', path: 'mobile/lib/services/sentiment_api.dart'),
        const _FileRow(component: 'Endpoint', path: 'backend/app/main.py'),
        const _FileRow(component: 'Model', path: 'backend/app/model_service.py'),
        const _FileRow(component: 'Metrik', path: 'backend/app/monitoring.py'),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Arah baliknya sama penting: model mengembalikan hasil ke API, API membentuk JSON, lalu frontend—Streamlit atau Flutter—menerjemahkannya menjadi tampilan yang dipahami pengguna.',
            ),
          ),
        ),
      ],
    );
  }
}

class _ArchitectureNode extends StatelessWidget {
  const _ArchitectureNode({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: active ? colors.primaryContainer : colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: active ? colors.primary : colors.outline, width: active ? 2 : 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: active ? colors.primary : colors.surfaceVariant,
            foregroundColor: active ? colors.onPrimary : colors.onSurface,
            child: Icon(icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle),
              ],
            ),
          ),
          if (active) const Icon(Icons.adjust),
        ],
      ),
    );
  }
}

class _FlowArrow extends StatelessWidget {
  const _FlowArrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          const Icon(Icons.arrow_downward, size: 20),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({required this.component, required this.path});

  final String component;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 105, child: Text(component, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: SelectableText(path)),
        ],
      ),
    );
  }
}

