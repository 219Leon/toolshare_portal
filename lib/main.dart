import 'package:flutter/material.dart';
import 'view/screens/SplashPage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToolShare Portal',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme.apply()),
                primarySwatch: const MaterialColor(
          0xFF0F51B0,
          <int, Color>{
            50: Color(0xFFE8F1FF),
            100: Color(0xFFC5DAFF),
            200: Color(0xFF9EC0FF),
            300: Color(0xFF76A6FF),
            400: Color(0xFF4E8DFF),
            500: Color(0xFF2673FF),
            600: Color(0xFF115FF6),
            700: Color(0xFF0D52DB),
            800: Color(0xFF0A47C0),
            900: Color(0xFF083BA7),
          },
        ),
      ),
      home: const SplashPage(),
    );
  }
}
