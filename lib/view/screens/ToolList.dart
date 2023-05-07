import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toolshare_portal/config.dart';
import 'package:ndialog/ndialog.dart';
import 'package:toolshare_portal/models/tools.dart';
import '../../models/user.dart';
import '../shared/mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ToolList extends StatefulWidget{
  final User user;
  const ToolList({super.key, required this.user});
  

  @override
  State<StatefulWidget> createState() => _ToolListState();
}

class _ToolListState extends State<ToolList>{
  var _lat, _lng;
  late Position _position;
  List<Tool> ToolList = <Tool>[];
  String titlecenter = "Loading...";
  var placemarks;
  //final df DateFormat('d/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  //int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _loadTools();
  }

@override
void dispose() {
  ToolList = [];
  print("dispose");
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: "Register New Tool",
            labelStyle: const TextStyle(),
            onTap: null
          ),
        ],
      ),
    );
  }

}

void _loadTools() {

}