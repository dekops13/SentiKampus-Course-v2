import 'package:flutter/material.dart';

import '../data/demo_weeks.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key, required this.selectedWeek});

  final int selectedWeek;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: demoWeeks.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Perjalanan Proyek', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 6),
                const Text(
                  'SentiKampus dibangun seperti tangga. Setiap pertemuan menambah satu kemampuan dan meninggalkan bukti yang dapat diaudit.',
                ),
              ],
            ),
          );
        }
        final week = demoWeeks[index - 1];
        final selected = week.week == selectedWeek;
        final completed = week.week < selectedWeek;
        final colors = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            color: selected ? colors.primaryContainer : colors.surface,
            child: ExpansionTile(
              initiallyExpanded: selected,
              leading: CircleAvatar(
                backgroundColor: selected
                    ? colors.primary
                    : completed
                        ? colors.secondaryContainer
                        : colors.surfaceVariant,
                foregroundColor: selected ? colors.onPrimary : colors.onSurface,
                child: completed ? const Icon(Icons.check, size: 19) : Text('${week.week}'),
              ),
              title: Text(week.title, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(week.level),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                _JourneyRow(icon: Icons.flag_outlined, label: 'Arah belajar', text: week.focus),
                const SizedBox(height: 10),
                _JourneyRow(icon: Icons.play_circle_outline, label: 'Demonstrasi', text: week.demoAction),
                const SizedBox(height: 10),
                _JourneyRow(icon: Icons.fact_check_outlined, label: 'Bukti capaian', text: week.evidence),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [for (final item in week.capabilities) Chip(label: Text(item))],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _JourneyRow extends StatelessWidget {
  const _JourneyRow({
    required this.icon,
    required this.label,
    required this.text,
  });

  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(text),
            ],
          ),
        ),
      ],
    );
  }
}

