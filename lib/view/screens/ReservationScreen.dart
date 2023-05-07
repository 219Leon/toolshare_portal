import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/models/user.dart';
import 'LoginScreen.dart';
import 'package:toolshare_portal/config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../shared/mainmenu.dart';

class ReservationScreen extends StatefulWidget {
  final User user;
  const ReservationScreen({super.key, required this.user});

  @override
  State<ReservationScreen> createState() => ReservationScreenState();
}

class ReservationScreenState extends State<ReservationScreen> {
  var _lat, _lng;
  late Position _position;
  List<Tool> toolList = <Tool>[];
  String titlecenter = "Loading...";
  var placemarks;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTools();
  }

  @override
  void dispose() {
    toolList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
        title: const Text(""),
      )),
    );
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }
  void _loadTools() {
    http.get(Uri.parse("uri"),)
    .then((response));
  }
}
