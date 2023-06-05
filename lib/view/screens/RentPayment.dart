import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/models/user.dart';
import 'LoginScreen.dart';
import 'package:toolshare_portal/config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../shared/mainmenu.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/tools.dart';
import 'package:open_file/open_file.dart';

class RentPayment extends StatefulWidget {
  final User user;
  final Tool tool;
  final User renter;
  const RentPayment(
      {super.key,
      required this.user,
      required this.tool,
      required this.renter});
  @override
  State<RentPayment> createState() => RentPaymentState();
}

class RentPaymentState extends State<RentPayment> {
  late double screenHeight, screenWidth, resWidth;
  DateTime dateTime = DateTime(2023, 05, 19, 10, 20);
  DateTime dateTime2 = DateTime(2023, 05, 20, 10, 20);
  @override
  void initState() {
    super.initState();
  }

  File? _image;
  var pathAsset = "assets/images/camera.png";
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    final totalHours = dateTime2.difference(dateTime).inHours;
    final rentPrice = double.parse(widget.tool.toolRentPrice ?? '0');
    final delivery = double.parse(widget.tool.toolDelivery ?? '0');
    final totalPrice = (rentPrice * totalHours) + delivery;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Rent Payment Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/checkout.png'),
            Text("Pay to ${widget.renter.name}",
                style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: screenWidth - 16,
              child: Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.none, width: 1),
                columnWidths: const {
                  0: FixedColumnWidth(70),
                  1: FixedColumnWidth(200),
                },
                children: [
                  TableRow(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Tool Name', style: TextStyle(fontSize: 20))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tool.toolName.toString(),
                            style: const TextStyle(fontSize: 20)),
                      ],
                    )
                  ]),
                  TableRow(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Tool Price', style: TextStyle(fontSize: 20))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "RM ${double.parse(widget.tool.toolRentPrice.toString()).toStringAsFixed(2)} per hour",
                            style: const TextStyle(fontSize: 20)),
                      ],
                    )
                  ]),
                  TableRow(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Rent Period (Start)',
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              final dateStart = await pickDate();
                              if (dateStart == null) return;

                              setState(() => dateTime = dateStart);
                            },
                            child: Text(
                                '${dateTime.year}/${dateTime.month}/${dateTime.day}')),
                        ElevatedButton(
                            onPressed: () async {
                              final timeStart = await pickTime();
                              if (timeStart == null) return;

                              final newDateTimeStart = DateTime(
                                dateTime.year,
                                dateTime.month,
                                dateTime.day,
                                timeStart.hour,
                                timeStart.minute,
                              );
                              setState(() => dateTime = newDateTimeStart);
                            },
                            child: Text('$hours:$minutes')),
                      ],
                    )
                  ]),
                  TableRow(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Rent Period (End)',
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final dateEnd = await pickDate();
                            if (dateEnd == null) return;

                            setState(() =>
                                dateTime2 = dateEnd); // Assign to dateTime2
                          },
                          child: Text(
                            '${dateTime2.year}/${dateTime2.month}/${dateTime2.day}',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final timeEnd = await pickTime();
                            if (timeEnd == null) return;

                            final newDateTimeEnd = DateTime(
                              dateTime2.year,
                              dateTime2.month,
                              dateTime2.day,
                              timeEnd.hour,
                              timeEnd.minute,
                            );
                            setState(() => dateTime2 = newDateTimeEnd); 
                          },
                          child: Text('$hours:$minutes'),
                        ),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Delivery Fee', style: TextStyle(fontSize: 20))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "RM ${double.parse(widget.tool.toolDelivery.toString()).toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 20)),
                      ],
                    )
                  ]),
                  TableRow(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Total Rent', style: TextStyle(fontSize: 20))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RM ${double.parse(totalPrice.toString()).toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 24),
                        )
                      ],
                    )
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: screenWidth - 16,
                child: Table(
                    border: TableBorder.all(
                        color: Colors.black, style: BorderStyle.none, width: 1),
                    columnWidths: const {
                      0: FixedColumnWidth(70),
                      1: FixedColumnWidth(200),
                    },
                    children: [
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Bank', style: TextStyle(fontSize: 20))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.renter.bankName.toString(),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        )
                      ]),
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Account No.', style: TextStyle(fontSize: 20))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.renter.bankAccount.toString(),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        )
                      ]),
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('E-Wallet', style: TextStyle(fontSize: 20))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.renter.eWallet.toString(),
                                style: const TextStyle(fontSize: 20)),
                            Text("(${widget.renter.phone})",
                                style: const TextStyle(fontSize: 20))
                          ],
                        )
                      ]),
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Upload receipt',
                                style: TextStyle(fontSize: 20))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                                onPressed: _pickFile,
                                child: const Text("Pick File")),
                          ],
                        )
                      ]),
                    ])),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _submitPayment, child: const Text("Submit Payment")),
          ],
        ),
      ),
    );
  }

  void _submitPayment() async {}

  void _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.indigo,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _uploadTransactionImage(_image);
    }
  }

  Future<DateTime?> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    return pickedDate;
  }

  Future<TimeOfDay?> pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return pickedTime;
  }

  void _uploadTransactionImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());
    http.post(Uri.parse("${Config.SERVER}/php/transaction.php"), body: {
      "userid": widget.user.id,
      "image": base64Image,
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {});
        //DefaultCacheManager manager = DefaultCacheManager();
        //manager.emptyCache(); //clears all data in cache.

      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
