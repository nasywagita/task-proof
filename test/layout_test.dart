import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_proof/dashboard.dart';

void main() {
  testWidgets('DashboardScreen renders without error', (WidgetTester tester) async {
    // Wrap with MaterialApp to provide MediaQuery and Theme
    await tester.pumpWidget(const MaterialApp(
      home: DashboardScreen(),
    ));

    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}
