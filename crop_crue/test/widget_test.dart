/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crop_crue/main.dart';

void main() {
  testWidgets('registration page shows fields and validates empty form', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);

    final createAccountButton = find.widgetWithText(
      ElevatedButton,
      'Create account',
    );
    await tester.ensureVisible(createAccountButton);
    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name'), findsOneWidget);
  });
}*/
