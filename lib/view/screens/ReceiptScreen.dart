import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/models/user.dart';

class ReceiptScreen extends StatefulWidget{
    final User user;
    final Tool tool;
    final User renter;
    const ReceiptScreen({super.key,
      required this.user,
      required this.tool,
      required this.renter});

  @override
  State<ReceiptScreen> createState() => _ReceiptState();
}

class _ReceiptState extends State<ReceiptScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
