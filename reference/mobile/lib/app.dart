import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/demo_weeks.dart';
import 'models/demo_week.dart';
import 'screens/analysis_page.dart';
import 'screens/architecture_page.dart';
import 'screens/journey_page.dart';
import 'screens/monitoring_page.dart';

class SentiKampusApp extends StatelessWidget {
  const SentiKampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SentiKampus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const SentiKampusShell(),
    );
  }
}

class SentiKampusShell extends StatefulWidget {
  const SentiKampusShell({super.key});

  @override
  State<SentiKampusShell> createState() => _SentiKampusShellState();
}

class _SentiKampusShellState extends State<SentiKampusShell> {
  int _navigationIndex = 0;
  int _weekIndex = 0;

  DemoWeek get _week => demoWeeks[_weekIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SentiKampus'),
            Text(
              'Laboratorium AI Mobile',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            initialValue: _weekIndex,
            tooltip: 'Pilih pertemuan',
            onSelected: (value) => setState(() => _weekIndex = value),
            itemBuilder: (context) => [
              for (var index = 0; index < demoWeeks.length; index++)
                PopupMenuItem(
                  value: index,
                  child: Text('P${demoWeeks[index].week} · ${demoWeeks[index].title}'),
                ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.school_outlined),
                  const SizedBox(width: 6),
                  Text('P${_week.week}'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _navigationIndex,
          children: [
            AnalysisPage(week: _week),
            JourneyPage(selectedWeek: _week.week),
            MonitoringPage(week: _week),
            ArchitecturePage(week: _week),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navigationIndex,
        onDestinationSelected: (value) => setState(() => _navigationIndex = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'Analisis',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Perjalanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_heart_outlined),
            selectedIcon: Icon(Icons.monitor_heart),
            label: 'Monitoring',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_tree_outlined),
            selectedIcon: Icon(Icons.account_tree),
            label: 'Arsitektur',
          ),
        ],
      ),
    );
  }
}

