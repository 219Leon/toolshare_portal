import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toolshare_portal/config.dart';
import 'package:ndialog/ndialog.dart';
import 'package:toolshare_portal/view/screens/detailscreen.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/view/screens/RegisterToolScreen.dart';
import '../../models/user.dart';
import '../shared/mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ToolList extends StatefulWidget {
  final User user;
  final Tool tool;
  final int selectedIndex;
  const ToolList(
      {super.key,
      required this.user,
      required this.tool,
      required this.selectedIndex});

  @override
  State<StatefulWidget> createState() => _ToolListState();
}

class _ToolListState extends State<ToolList> {
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
            title: const Text("Tool List"),
          ),
          body: toolList.isEmpty
              ? Center(
                  child: Text(
                    titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                )
              : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Current tools available (${toolList.length} found)",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Expanded(
                          child: GridView.count(
                        crossAxisCount: rowcount,
                        children: List.generate(toolList.length, (index) {
                          print(toolList);
                          return Card(
                            elevation: 8,
                            child: InkWell(
                              onTap: () {
                                _showDetails(index);
                              },
                              onLongPress: () {
                                _deleteDialog(index);
                              },
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Flexible(
                                      flex: 7,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Config.SERVER}/assets/toolimages/${toolList[index].toolId}.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )),
                                  Flexible(
                                      flex: 7,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Text(
                                              truncateString(
                                                  toolList[index]
                                                      .toolName
                                                      .toString(),
                                                  15),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "RM ${double.parse(toolList[index].toolRentPrice.toString()).toStringAsFixed(2)} per hour"),
                                            Text(df.format(DateTime.parse(
                                                toolList[index]
                                                    .toolDate
                                                    .toString())), style:const TextStyle(fontSize: 10),)
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        }),
                      ))
                    ],
                  ),
          drawer: MainMenuWidget(user: widget.user, tool: widget.tool),
          floatingActionButton: FloatingActionButton(
            onPressed: _gotoNewTool,
            tooltip: 'Add new tool',
            child: const Icon(Icons.add_rounded),
          ),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  Future<void> _gotoNewTool() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        blur: 10,
        title: null,
        message: const Text("Searching your current location..."));
    progressDialog.show();
    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => RegisterToolScreen(
                  user: widget.user,
                  tool: widget.tool,
                  position: _position,
                  placemarks: placemarks)));
      _loadTools();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14);
    }
  }

  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

  void _loadTools() {
    
  http.get(
    Uri.parse("${Config.SERVER}/php/loadrentertools.php?userid=${widget.user.id}"),
  ).then((response) {
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['tools'] != null) {
          setState(() {
            toolList = List<Tool>.from(
              extractdata['tools'].map((toolJson) => Tool.fromJson(toolJson)),
            );
            print(toolList[0].toolId);
            titlecenter = "Found";
          });
        } else {
          setState(() {
            titlecenter = "No tools available";
            toolList.clear();
          });
        }
      } else {
        setState(() {
          titlecenter = "No tools available";
          toolList.clear();
        });
      }
    } else {
      setState(() {
        titlecenter = "No tools available";
        toolList.clear();
      });
    }
  });
}

  Future<void> _showDetails(int index) async {
    Tool tool = Tool.fromJson(toolList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailScreen(user: widget.user, tool: tool)));
    _loadTools();
  }

  _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(toolList[index].toolName.toString(), 15)}?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure? This cannot be undone.", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deletetool(index);
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

  void _deletetool(index) {
    try {
      http.post(Uri.parse("${Config.SERVER}/php/delete_tool.php"),
          body: {'tool_id': toolList[index].toolId}).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Tool deleted successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadTools();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
