import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:famka/main.dart';

void main() {
  testWidgets('App renders home screen with welcome text',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const FamkaApp());

    // Allow routing to settle
    await tester.pumpAndSettle();

    // Verify that the welcome screen is shown
    expect(find.text('Welcome to famka'), findsOneWidget);
    expect(find.text('famka'), findsAtLeast(1));
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('Navigation bar is present with all destinations',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FamkaApp());
    await tester.pumpAndSettle();

    // Verify navigation destinations are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
