import 'package:educode_ai/src/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EduCode AI navigation opens the course catalog', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EduCodeApp()));

    expect(find.text('EduCode AI'), findsOneWidget);
    expect(find.text('Xush kelibsiz! 👋'), findsOneWidget);

    await tester.tap(find.text('Kurslar').last);
    await tester.pumpAndSettle();

    expect(find.text('Bilimingizni keyingi bosqichga olib chiqing'), findsOneWidget);
    expect(find.text('Barcha kurslar'), findsOneWidget);

    await tester.ensureVisible(find.text('Python dasturlash'));
    await tester.pumpAndSettle();
    expect(find.text('Python dasturlash'), findsOneWidget);
  });

  testWidgets('Practice and profile tabs can be opened', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EduCodeApp()));

    await tester.tap(find.text('Amaliyot'));
    await tester.pumpAndSettle();
    expect(find.text('Kod yozish orqali o‘rganing'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Yangi o‘quvchi'), findsOneWidget);
  });
}
