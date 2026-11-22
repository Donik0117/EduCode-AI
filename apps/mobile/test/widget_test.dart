import 'package:educode_ai/src/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('EduCode AI home screen renders core sections', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: EduCodeApp()),
    );

    expect(find.text('EduCode AI'), findsOneWidget);
    expect(find.text('Xush kelibsiz! 👋'), findsOneWidget);
    expect(find.text('AI Mentor'), findsOneWidget);
    expect(find.text('Python dasturlash'), findsOneWidget);
  });
}
