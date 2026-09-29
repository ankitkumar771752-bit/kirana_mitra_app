// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:kiranamitra/main.dart';

void main() {
  testWidgets('KiranaMitra unified app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KiranaMitraApp());

    // Verify that our module selection screen appears.
    expect(find.text('KiranaMitra Unified App'), findsOneWidget);
    expect(find.text('Customer App Module'), findsOneWidget);
  });
}
