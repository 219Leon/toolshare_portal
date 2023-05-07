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
import 'package:file_picker/file_picker.dart';

class RentPayment extends StatefulWidget{
  final User user;  
  const RentPayment({super.key, required this.user});
@override
State<RentPayment> createState() => RentPaymentState();
}

class RentPaymentState extends State<RentPayment>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}