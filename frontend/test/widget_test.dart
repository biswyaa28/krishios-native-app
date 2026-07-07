import 'package:flutter_test/flutter_test.dart';
import 'package:krishios/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KrishiOSApp());
    expect(find.text('KrishiOS'), findsWidgets);
  });
}
