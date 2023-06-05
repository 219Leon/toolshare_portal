import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:toolshare_portal/view/screens/LoginScreen.dart';
import '../../config.dart';

class RegisterAccountScreen extends StatefulWidget{
  const RegisterAccountScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccountScreen> {
  @override
  void initState() {
    super.initState();
    loadEula();
  }

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();

  bool _isChecked = false;
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  String eula = "";

  late double screenHeight, screenWidth, resWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          upperHalf(context),
          lowerHalf(context)
        ],
      ),
    );
  }

  Widget upperHalf(BuildContext context){
    return SizedBox(
      height: screenHeight / 2,
      width: screenWidth,
      child: Image.asset('assets/images/LoginScreen.png', 
      fit: BoxFit.cover,),
    );
  }

  Widget lowerHalf(BuildContext context){
    return Container(
      height:600,
      margin: EdgeInsets.only(top: screenHeight /5),
      padding: const EdgeInsets.only(left:10, right:10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                  children: <Widget>[
                    const SizedBox(height:10),
                    const Text(
                      "Register New Account",
                        style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || val.length<3
                      ? "Please enter a valid username!"
                      : null,
                      controller: _nameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                      ),
                      icon: Icon(Icons.person_outline),
                      focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide( width: 2.0),
                    ))),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty ||
                              !val.contains("@") ||
                              !val.contains(".")
                              ? "Please enter a valid email!"
                              : null,
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                      ),
                      icon: Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide( width: 2.0),
                    ))),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty||val.length<10
                      ?"Please enter a valid phone number!"
                      :null,
                      controller: _phoneEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                      ),
                      icon: Icon(Icons.phone_outlined),
                      focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide( width: 2.0),
                    ))),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => validatePassword(val.toString()),
                      controller: _passEditingController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                      ),
                      icon: Icon(Icons.lock_outline),
                      focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide( width: 2.0),
                    )),
                    obscureText: true),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (val) => validatePassword(val.toString()),
                      controller: _pass2EditingController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                      labelText: 'Re-enter Password',
                      labelStyle: TextStyle(
                      ),
                      icon: Icon(Icons.lock_outline),
                      focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide( width: 2.0),
                    )),
                    obscureText: true),
                  const SizedBox(
                    height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Checkbox(
                        value: _isChecked, 
                        onChanged: (bool? value){
                          setState(() {
                            _isChecked = value!;
                          });
                        }),
                      Flexible(
                        child: GestureDetector(
                          onTap: showEula,
                          child: const Text("I agree with the terms stated",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),),
                        )),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                        minWidth: 115,
                        height: 50,
                        child: const Text('Register'),
                        elevation: 10,
                        color: Colors.blue,
                        onPressed: _registerAccountDialog
                        ),    
                    ],
                  ),  
                ]),
                ),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Already registered?",
              style: TextStyle(fontSize: 15.0, )),
              GestureDetector(
                onTap: () => {
                      Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (BuildContext context) => 
                          const LoginScreen()))
                    },
                child: const Text(" Login now!",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          ],
      )),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Please enter a valid password!';
      } else {
        return null;
      }
    }
  }
  
  void _registerAccountDialog() {
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _phone = _phoneEditingController.text;
    String _passa = _passEditingController.text;
    String _passb = _pass2EditingController.text;

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Incomplee registration credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept the terms and conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (_passa != _passb) {
      Fluttertoast.showToast(
          msg: "Invalid password. Please check again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser(_name, _email, _phone, _passa);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  loadEula() async {
    WidgetsFlutterBinding.ensureInitialized();
    eula = await rootBundle.loadString('assets/images/eula.txt');
  }

  showEula() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _registerUser(String name, String email, String phone, String pass) {
    try {
      http.post(Uri.parse("${Config.SERVER}/toolshare_portal/php/register_user.php"), body: {
        "name": name,
        "email": email,
        "phone": phone,
        "password": pass,
        "register": "register"
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Registration successful. Please login",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          print("Register success");  
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Registration Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          print("Register failed"); 
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
