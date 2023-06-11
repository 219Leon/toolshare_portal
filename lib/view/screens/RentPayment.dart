import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ndialog/ndialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/models/user.dart';
import 'package:toolshare_portal/config.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:toolshare_portal/view/screens/ReceiptScreen.dart';
import '../screens/HomeScreen.dart';

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
  DateTime dateTime = DateTime.now();
  DateTime dateTime2 = DateTime.now();
  final GlobalKey _screenshotKey = GlobalKey();


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
    final hours2 = dateTime2.hour.toString().padLeft(2, '0');
    final minutes2 = dateTime2.minute.toString().padLeft(2, '0');
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/checkout.png'),
                Text("Pay to ${widget.renter.name}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
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
                            Text('Tool Name', style: TextStyle(fontSize: 16))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.tool.toolName.toString(),
                                style: const TextStyle(fontSize: 16)),
                          ],
                        )
                      ]),
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Tool Price', style: TextStyle(fontSize: 16))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "RM ${double.parse(widget.tool.toolRentPrice.toString()).toStringAsFixed(2)} per hour",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        )
                      ]),
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Rent Period (Start)',
                                style: TextStyle(fontSize: 16))
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
                                style: TextStyle(fontSize: 16))
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
                              child: Text('$hours2:$minutes2'),
                            ),
                          ],
                        ),
                      ]),
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Delivery Fee', style: TextStyle(fontSize: 16))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "RM ${double.parse(widget.tool.toolDelivery.toString()).toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        )
                      ]),
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Total Rent', style: TextStyle(fontSize: 16))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "RM ${double.parse(totalPrice.toString()).toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 18),
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
                            color: Colors.black,
                            style: BorderStyle.none,
                            width: 1),
                        columnWidths: const {
                          0: FixedColumnWidth(70),
                          1: FixedColumnWidth(200),
                        },
                        children: [
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Bank', style: TextStyle(fontSize: 16))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.renter.bankName.toString(),
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            )
                          ]),
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Account No.',
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.renter.bankAccount.toString(),
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            )
                          ]),
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('E-Wallet', style: TextStyle(fontSize: 16))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.renter.eWallet.toString(),
                                    style: const TextStyle(fontSize: 16)),
                                Text("(${widget.renter.phone})",
                                    style: const TextStyle(fontSize: 16))
                              ],
                            )
                          ]),
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Upload receipt',
                                    style: TextStyle(fontSize: 16))
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
                    onPressed: _submitPaymentDialog,
                    child: const Text("Submit Payment")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitPaymentDialog() {
    if (dateTime2.isBefore(dateTime)) {
      Fluttertoast.showToast(
          msg:
              "The start date and time must occur before the end date and time",
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
              "Submit payment?",
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
                  _showReceipt();
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
        });
  }

  _showReceipt() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Payment Successful!",
              style: TextStyle(),
            ),
            content: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                Image.asset('assets/images/success.png'),
                const SizedBox(height: 20,),
                const Text("Rent paid", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),                
                  SizedBox(
                  child: Table(
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.none,
                          width: 1),
                      columnWidths: const {
                        0: FixedColumnWidth(90),
                        1: FixedColumnWidth(10),
                        2: FixedColumnWidth(200),
                      },
                      children: [
                        TableRow(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Paid by:', style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user.name.toString(),
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          )
                        ]),
                        TableRow(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Paid to:', style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.renter.name.toString(),
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          )
                        ]),
                         TableRow(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Tool rented:', style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.tool.toolName.toString(),
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          )
                        ]),
                        TableRow(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Transaction time:', style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()).toString(),
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          )
                        ]),
                                                TableRow(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Rent Period:', style: TextStyle(fontSize: 13))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${DateFormat('yyyy-MM-dd HH:mm').format(dateTime).toString()} to ${DateFormat('yyyy-MM-dd HH:mm').format(dateTime2).toString()}',
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          )
                        ]),
                        ]
                  )),                
                    const SizedBox(height: 10,),
                    const Text("Rent Terms and Conditions", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    const Text("1. This transaction is final and no refunds are allowed upon the time sipulated.", style: TextStyle(fontSize: 8)),
                    const Text("2. The renter shall not be liable for any injuries, loss or damage occured during the rent period.", style: TextStyle(fontSize: 8)),
                    const Text("3. In the case of loss or theft, notify immediately to the renter and rentees shall be responsible for the replacement cost and any associated expenses.", style: TextStyle(fontSize: 8)),
                    const Text("4. A late penalty will be imposed upon overtime rent period.", style: TextStyle(fontSize: 8)),
                    const Text("5. The renter reserves any right(s) to refuse and terminate services for rentees who violated the terms sipulated.", style: TextStyle(fontSize: 8)),
                  ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Save",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _savePayment();
                },
              ),
              TextButton(
                child: const Text(
                  "Return",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                              selectedIndex: 0,
                              user: widget.user,
                              tool: widget.tool)));
                },
              ),
            ],
          );
        });
  }

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

  void _savePayment() async {
    RenderRepaintBoundary? boundary = _screenshotKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 1.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final directory = (await getExternalStorageDirectory())?.path;
      final String filePath = '$directory/screenshot.png';
      final File file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      Fluttertoast.showToast(
        msg: "Screenshot saved to $filePath",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
    }
  }
}
