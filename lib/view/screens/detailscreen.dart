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
  @override
  void initState() {
    super.initState();
    _tonameEditingController.text = widget.tool.toolName.toString();
    _todescEditingController.text = widget.tool.toolDesc.toString();
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
                        "${Config.SERVER}/assets/toolimages/${widget.tool.toolId}.png",
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
                                      ? "Field must not be empty"
                                      : null,
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
                              controller: _tolocalEditingController,
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
                              controller: _todelEditingController,
                              validator: (val) =>
                                  val!.isEmpty ? "Must contain value" : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Delivery Fees (Optional)',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.delivery_dining),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )),
                            )),
                        Flexible(
                            flex: 5,
                            child: CheckboxListTile(
                                title: const Text(
                                    "I hereby declare that the details I provided are true"),
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                })),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        child: const Text('Update Tool'),
                        onPressed: () => _updateToolDialog(),
                      ),
                    )
                  ],
                )),
          )
        ],
      )),
    );
  }

  _updateToolDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please check the verification checkbox",
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
            "Update this tool?",
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
                _updateTool();
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

  void _updateTool() async {
    String toname = _tonameEditingController.text;
    String todesc = _todescEditingController.text;
    String toprice = _topriceEditingController.text;
    String delivery = _todelEditingController.text;
    String qty = _toqtyEditingController.text;

    var response = await http.post(Uri.parse('${Config.SERVER}/php/update_tool.php'), body: {
      'toolid': widget.tool.toolId,
      'userid': widget.user.id,
      'toname': toname,
      'todesc': todesc,
      'toprice': toprice,
      'delivery': delivery,
      'qty': qty,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Edit tool success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Edit tool failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}
