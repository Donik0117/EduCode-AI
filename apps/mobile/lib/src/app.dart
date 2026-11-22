import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/auth/presentation/auth_gate.dart';

class EduCodeApp extends StatelessWidget {
  const EduCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF695CFF),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'EduCode AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1020),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF151C30),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF26314A)),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
