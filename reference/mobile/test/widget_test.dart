import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sentikampus_mobile/app.dart';

void main() {
  testWidgets('halaman awal menampilkan laboratorium prediksi', (tester) async {
    await tester.pumpWidget(const SentiKampusApp());

    expect(find.text('SentiKampus'), findsOneWidget);
    expect(find.text('Laboratorium prediksi'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Analisis Sentimen'), findsOneWidget);
  });
}

