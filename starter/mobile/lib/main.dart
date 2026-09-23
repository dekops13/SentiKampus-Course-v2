import 'package:flutter/material.dart';

void main() => runApp(const SentiKampusStarter());

class SentiKampusStarter extends StatelessWidget {
  const SentiKampusStarter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('SentiKampus Android')),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'TODO P12: buat UI Android yang memakai kontrak FastAPI yang sama dengan web.',
          ),
        ),
      ),
    );
  }
}
