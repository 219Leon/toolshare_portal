import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/models/user.dart';
import 'package:toolshare_portal/models/transaction.dart';
import '../screens/HomeScreen.dart';
import '../shared/mainmenu.dart';

class ReceiptScreen extends StatefulWidget {
  final User user;
  final Tool tool;
  final User renter;
  ReceiptScreen(
      {super.key,
      required this.user,
      required this.tool,
      required this.renter,
      });

  @override
  State<ReceiptScreen> createState() => _ReceiptState();
}

class _ReceiptState extends State<ReceiptScreen> {
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  final GlobalKey _screenshotKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Receipt")),
      body: RepaintBoundary(
        key: _screenshotKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Image.asset('assets/images/success.png'),
              Text("Transaction Successful!",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
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
                          Text('Transaction ID:',
                              style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         // Text(widget.transaction.transactionId.toString(),style: const TextStyle(fontSize: 16)),
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Transaction date:',
                              style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  //        Text(df.format(DateTime.parse(widget.transaction.transactionDate.toString())))
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Pay to:', style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.renter.name.toString(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Start Date:', style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    //      Text(df.format(DateTime.parse(widget.transaction.startDate.toString())))
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('End Date:', style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                     //     Text(df.format(DateTime.parse(widget.transaction.endDate.toString())))
                        ],
                      )
                    ]),
                    TableRow(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Total Price:', style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                     //     Text("RM ${double.parse(widget.transaction.totalPrice.toString()).toStringAsFixed(2)}",style: const TextStyle(fontSize: 16)),
                        ],
                      )
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _saveReceipt, child: const Text("Save Receipt")),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: _returnHome, child: const Text("Return Home")),
            ],
          ),
        ),
      ),
      drawer: MainMenuWidget(user: widget.user, tool: widget.tool),
    );
  }

  void _saveReceipt() async {
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

  void _returnHome() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                selectedIndex: 0, user: widget.user, tool: widget.tool)));
  }
}
