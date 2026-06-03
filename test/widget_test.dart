import 'package:flutter_test/flutter_test.dart';
import 'package:maestronesia/main.dart';

void main() {
  testWidgets('App splash screen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaestronesiaApp());

    // Verify that the splash screen shows MAESTRONESIA
    expect(find.text('MAESTRONESIA'), findsOneWidget);
    expect(find.text('EMPOWERING EXPERTISE'), findsOneWidget);
  });
}
