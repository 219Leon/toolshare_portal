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
  DateTime dateTime = DateTime(2023, 05, 11, 10, 20);
  String _fileText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    //Duration df = dt2.difference(dt1);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Rent Pyment")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Pay to ${widget.renter.username}",
              style: const TextStyle(
                fontSize: 24,
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
                          style: const TextStyle(fontSize: 20))
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
                      Text("RM ${widget.tool.toolRentPrice} per hour",
                          style: const TextStyle(fontSize: 20))
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
                  Column(
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
                      Text('Rent Period (End)', style: TextStyle(fontSize: 20))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  )
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
                      Text("RM ${widget.tool.toolDelivery}",
                          style: const TextStyle(fontSize: 20))
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
                      Text("RM ${widget.tool.toolDelivery}",
                          style: const TextStyle(fontSize: 24))
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
                              style: const TextStyle(fontSize: 20))
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
                              style: const TextStyle(fontSize: 20))
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
                              style: const TextStyle(fontSize: 20))
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Upload receipt', style: TextStyle(fontSize: 20))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              onPressed: _pickFile,
                              child: const Text("Pick File")),
                          Text(_fileText),
                        ],
                      )
                    ]),
                  ])),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: _submitPayment, 
              child: const Text("Submit Payment")),
        ],
      ),
    );
  }

  void _submitPayment() async {}

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'pdf', 'png'],allowMultiple: false);
    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;
      viewFile(file);
    } else if (result == null) {
      return;
    }
  }

  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));



}
