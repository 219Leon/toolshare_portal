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
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
      return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/SplashScreen.png'),
              fit: BoxFit.cover))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            SizedBox(height:120),
            CircularProgressIndicator(),
            Text("Version 1.0.1",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
              ),
            ],),
        )],
    );
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String pass = (prefs.getString('pass')) ?? '';
    if (email.isNotEmpty){
        http.post(Uri.parse("${Config.SERVER}/php/login_user.php"),
        body: {"email": email, "password": pass}).then((response) {
            print(response.body);
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          User user = User.fromJson(jsonResponse['data']);
          Timer(
            const Duration(seconds: 3), 
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (content) => DashboardScreen(user: user))));
        } else {
          Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => LoginScreen())));
        }
    });
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => LoginScreen())));
    }
  }
}