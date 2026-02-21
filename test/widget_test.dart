import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_hub/app.dart';

void main() {
  testWidgets('AI Hub app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AIHubApp(),
      ),
    );

    expect(find.text('AI Hub'), findsOneWidget);
  });
}
