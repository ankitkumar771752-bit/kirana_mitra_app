import 'package:flutter_test/flutter_test.dart';
import 'package:kiranamitra/main.dart';

void main() {
  testWidgets('KiranaMitra splash screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KiranaMitraApp());

    // Verify that Splash screen appears.
    expect(find.text('KiranaMitra'), findsWidgets);

    // Pump past the 3-second splash timer
    await tester.pump(const Duration(seconds: 3));
  });
}
