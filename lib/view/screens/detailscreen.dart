import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toolshare_portal/config.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/models/user.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final Tool tool;
  final User user;
  const DetailScreen({Key? key, required this.user, required this.tool})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var pathAsset = "assets/images/camera.png";
  bool _isChecked = false;
  final TextEditingController _tonameEditingController =
      TextEditingController();
  final TextEditingController _todescEditingController =
      TextEditingController();
  final TextEditingController _topriceEditingController =
      TextEditingController();
  final TextEditingController _todelEditingController = TextEditingController();
  final TextEditingController _toqtyEditingController = TextEditingController();
  final TextEditingController _tostateEditingController =
      TextEditingController();
  final TextEditingController _tolocalEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  late List<Widget> tabchildren;
  int _currentIndex = 2;
  String maintitle = "Tool List";
  @override
  void initState() {
    super.initState();
    _tonameEditingController.text = widget.tool.toolName.toString();
    _todescEditingController.text = widget.tool.toolDescription.toString();
    _topriceEditingController.text = widget.tool.toolRentPrice.toString();
    _todelEditingController.text = widget.tool.toolDelivery.toString();
    _toqtyEditingController.text = widget.tool.toolQty.toString();
    _tostateEditingController.text = widget.tool.toolState.toString();
    _tolocalEditingController.text = widget.tool.toolLocal.toString();

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Editing Details")),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Card(
              elevation: 8,
              child: Container(
                height: screenHeight / 3,
                width: resWidth,
                child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${Config.SERVER}/assets/toolimages/${widget.tool.toolID}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: ((context, url, error) =>
                        const Icon(Icons.error))),
              )),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Tool Details",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _tonameEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Tool name must be longer than 3"
                            : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Tool Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.precision_manufacturing),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _todescEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 10)
                            ? "Tool description must be longer than 10"
                            : null,
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Tool Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.person,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _topriceEditingController,
                              validator: (val) => val!.isEmpty
                                  ? "Tool Rent price must contain value"
                                  : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Tool Rent Price',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )),
                            )),
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _toqtyEditingController,
                              validator: (val) => val!.isEmpty
                                  ? "Quantity should be at least 1"
                                  : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Tool Quantity',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.ad_units),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _tostateEditingController,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                  ? "Field must not be empty" : null,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current State',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )),
                            )),
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _topriceEditingController,
                              validator: (val) => 
                                val!.isEmpty || (val.length < 3)
                                ? "Field must not be empty"
                                : null,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current Location',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.map),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _topriceEditingController,
                        validator: (val) => val!.isEmpty
                                ? "Tool Rent price must contain value"
                                : null,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tool Rental Price',
                          labelStyle: TextStyle(),
                                icon: Icon(Icons.money),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                  )),
                      )),
                      ],
                    ),
                  ],
                )),
          )
        ],
      )),
    );
  }
    void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Dashboard";
      } else if (_currentIndex == 1) {
        maintitle = "Tool Marketplace";
      } else if (_currentIndex == 2) {
        maintitle = "Tool List";
      } else if (_currentIndex == 3) {
        maintitle = "Account";
      }
    });
  }
}
