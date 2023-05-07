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
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}
