import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolshare_portal/view/screens/LoginScreen.dart';
import '../../config.dart';
import '../../models/user.dart';
import 'DashboardScreen.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 8),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/SplashScreen1.png'),
                  fit: BoxFit.cover)
              ),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          SizedBox(height:120),
          CircularProgressIndicator(),
          Text(
            "Version 1.0.1",
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black
            ),
          )
        ],),)
      ],
    );
  }
}
