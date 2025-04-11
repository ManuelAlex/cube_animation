// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cube_animation/main.dart';

void main() {
  testWidgets('Cube is visible', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('Right tap moves cube to the right', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final containerFinder = find.byType(Container);
    final Offset initial = tester.getCenter(containerFinder);

    await tester.tap(find.text('Right'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final Offset mid = tester.getCenter(containerFinder);
    expect(mid.dx > initial.dx, true);

    await tester.pumpAndSettle();
  });

  testWidgets('Left tap moves cube to the left', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // First move to right
    await tester.tap(find.text('Right'));
    await tester.pumpAndSettle();

    final Finder containerFinder = find.byType(Container);
    final Offset rightPos = tester.getCenter(containerFinder);

    // Now move to left
    await tester.tap(find.text('Left'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final Offset mid = tester.getCenter(containerFinder);

    expect(mid.dx < rightPos.dx, true);

    await tester.pumpAndSettle();
  });

  testWidgets('Both buttons are enabled initially', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final left = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Left'),
    );
    final right = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Right'),
    );

    expect(left.onPressed, isNotNull);
    expect(right.onPressed, isNotNull);
  });

  testWidgets('Left button is disabled when cube is on the left', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Left'));
    await tester.pumpAndSettle();

    final left = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Left'),
    );
    final right = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Right'),
    );

    expect(left.onPressed, isNull);
    expect(right.onPressed, isNotNull);
  });

  testWidgets('Right button is disabled when cube is on the right', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Right'));
    await tester.pumpAndSettle();

    final left = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Left'),
    );
    final right = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Right'),
    );

    expect(right.onPressed, isNull);
    expect(left.onPressed, isNotNull);
  });

  testWidgets('Both buttons disabled during animation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Right'));
    await tester.pump(); // start animation

    final left = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Left'),
    );
    final right = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Right'),
    );

    expect(left.onPressed, isNull);
    expect(right.onPressed, isNull);

    await tester.pumpAndSettle();
  });
}
