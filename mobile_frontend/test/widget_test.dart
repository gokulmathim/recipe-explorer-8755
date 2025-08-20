import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart' as app;

void main() {
  testWidgets('App renders login or home', (WidgetTester tester) async {
    // Initialize the app by calling main (non-async) then pump frames.
    app.main();

    // Let the widgets build and settle.
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Either Login (Welcome) or Home (Recipe Explorer) should be present
    final loginTitle = find.textContaining('Welcome');
    final homeTitle = find.text('Recipe Explorer');

    expect(loginTitle.evaluate().isNotEmpty || homeTitle.evaluate().isNotEmpty, true);
  });
}
