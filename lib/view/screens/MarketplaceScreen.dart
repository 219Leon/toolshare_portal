import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toolshare_portal/config.dart';
import '../../models/user.dart';
import '../../models/tools.dart';
import '../shared/mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import '../screens/DashboardScreen.dart';
import '../screens/ToolList.dart';
import '../screens/ProfileScreen.dart';
import '../screens/RenteeToolDetails.dart';

class MarketplaceScreen extends StatefulWidget {
  final User user;
  final Tool tool;
  const MarketplaceScreen({super.key, required this.user, required this.tool});

  @override
  State<MarketplaceScreen> createState() => _marketplaceScreenState();
}

class _marketplaceScreenState extends State<MarketplaceScreen> {
  List<Tool> toolList = <Tool>[];
  String titlecenter = "Loading tools...";
  final df = DateFormat('dd/mm/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 1;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var renter;
  var color;
  var numofpage, curpage = 1;
  int numberofresult = 0;
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Marketplace";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadTools("all", 1);
    });
    tabchildren = [
      DashboardScreen(
        user: widget.user,
        tool: widget.tool,
      ),
      MarketplaceScreen(user: widget.user, tool: widget.tool),
      ToolList(user: widget.user, tool: widget.tool),
      ProfileScreen(user: widget.user, tool: widget.tool),
    ];
  }

  @override
  void dispose() {
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
          title: const Text("Search Tools"),
          actions: [
            IconButton(
                onPressed: () {
                  _loadSearchDialog();
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: toolList.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Available Tools ($numberofresult found)",
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
                      return Card(
                        elevation: 8,
                        child: InkWell(
                            onTap: () {
                              _showDetails(index);
                            },
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    imageUrl: "",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
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
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "RM ${double.parse(toolList[index].toolRentPrice.toString()).toStringAsFixed(2)} per hour"),
                                          Text(df.format(DateTime.parse(
                                              toolList[index]
                                                  .toolDate
                                                  .toString())))
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                      );
                    }),
                  )),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage - 1) == index) {
                            color = Colors.red;
                          } else {
                            color = Colors.black;
                          }
                          return TextButton(
                              onPressed: () => {_loadTools(search, index + 1)},
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ));
                        }),
                  ),
                ],
              ),
                        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.house), label: "Dashboard",),
              BottomNavigationBarItem(
                  icon: Icon(Icons.store_mall_directory),
                  label: "Marketplace"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt), label: "Tool List"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
            ],
          ),
        drawer: MainMenuWidget(
          user: widget.user,
          tool: widget.tool,
        ),
      ),
    );
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void _loadTools(String search, int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http
        .get(
      Uri.parse(
          "${Config.SERVER}/php/loadalltools.php?=search=$search&pageno=$pageno"),
    )
        .then((response) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 5,
        message: const Text("Loading..."),
        title: null,
      );
      progressDialog.show();
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata =
            jsonDecode(response.body); 
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data']; 

          if (extractdata['products'] != null) {
            numofpage = int.parse(jsondata['numofpage']); 
            numberofresult = int.parse(jsondata[
                'numberofresult']); 
            toolList = <Tool>[]; 
            extractdata['products'].forEach((v) {
              toolList.add(Tool.fromJson(
                  v)); 
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Product Available"; 
            toolList.clear();
          }
        }
      } else {
        titlecenter = "No Product Available"; 
        toolList.clear(); 
      }

      setState(() {}); 
      progressDialog.dismiss();
    });
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

  _loadSearchDialog() {}

  _showDetails(int index) async{
    Tool tool = Tool.fromJson(toolList[index].toJson());
    loadSingleRenter(index);
    ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 5,
        message: const Text("Loading..."),
        title: null,
      );
    progressDialog.show();
    Timer(const Duration(
      seconds: 1), 
      () {
        if(renter != null){
          progressDialog.dismiss();
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (content) => RenteeToolDetails(user: widget.user, tool: tool, renter: widget.user,)
              ));
        }
      } );
  }

  loadSingleRenter(int index) async{

  }
}
