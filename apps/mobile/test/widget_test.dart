import 'package:educode_ai/src/app.dart';
import 'package:educode_ai/src/features/auth/application/auth_controller.dart';
import 'package:educode_ai/src/features/auth/data/auth_repository.dart';
import 'package:educode_ai/src/features/auth/data/models/auth_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _FakeAuthRepository implements AuthRepository {
  AuthUser? _user;

  @override
  Future<AuthUser?> currentUser() async => _user;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    _user = AuthUser(
      id: 'test-user',
      email: email.toLowerCase(),
      fullName: 'Test Student',
      role: 'student',
      isActive: true,
    );
    return _user!;
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _user = AuthUser(
      id: 'test-user',
      email: email.toLowerCase(),
      fullName: fullName,
      role: 'student',
      isActive: true,
    );
    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
  }
}

Widget _buildApp(_FakeAuthRepository repository) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWith((ref) => repository),
    ],
    child: const EduCodeApp(),
  );
}

void main() {
  testWidgets('Unauthenticated user sees the login form', (tester) async {
    await tester.pumpWidget(_buildApp(_FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('EduCode AI'), findsOneWidget);
    expect(find.text('Xush kelibsiz'), findsOneWidget);
    expect(find.text('Kirish'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.text('Ro‘yxatdan o‘tish'));
    await tester.pumpAndSettle();

    expect(find.text('Hisob yaratish'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
  });

  testWidgets('Student can sign in and navigate the application', (tester) async {
    await tester.pumpWidget(_buildApp(_FakeAuthRepository()));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'student@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Password123!',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Kirish'));
    await tester.pumpAndSettle();

    expect(find.text('Xush kelibsiz! 👋'), findsOneWidget);

    await tester.tap(find.text('Kurslar').last);
    await tester.pumpAndSettle();
    expect(find.text('Barcha kurslar'), findsOneWidget);

    await tester.tap(find.text('Amaliyot'));
    await tester.pumpAndSettle();
    expect(find.text('Kod yozish orqali o‘rganing'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Test Student'), findsOneWidget);
    expect(find.text('Hisobdan chiqish'), findsOneWidget);
  });
}
