import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toolshare_portal/view/screens/HomeScreen.dart';
import 'package:toolshare_portal/view/screens/RegisterAccountScreen.dart';

import '../../config.dart';
import '../../models/user.dart';
import '../../models/transaction.dart';

class ReservationList extends StatefulWidget {
  final User user;
  const ReservationList({super.key, required this.user});

  @override
  State<ReservationList> createState() => ReservationListState();
}

class ReservationListState extends State<ReservationList> {
  List<Transaction> transactionList = <Transaction>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  double totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    loadTransaction();
  }

  @override
  Widget build(BuildContext context) {
 screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Notifications"),
      ),
      body: Column(
        children: [
          transactionList.isEmpty
              ? Container()
              : Expanded(
                  child: ListView.builder(
                      itemCount: transactionList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth / 3,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Config.SERVER}/mynelayan/assets/catches/${transactionList[index].toolId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        transactionList[index].toolName.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.remove)),
                                          //Text(transactionList[index].catchQty.toString()),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.add),
                                          )
                                        ],
                                      ),
                                      //Text("RM ${double.parse(transactionList[index].cartPrice.toString()).toStringAsFixed(2)}")
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {}, icon: const Icon(Icons.delete))
                            ],
                          ),
                        ));
                      })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Current Notifications available: ${transactionList.length}")
                  ],
                )),
          )
        ],
      ),
    );
  }

  void loadTransaction(){

  }
}