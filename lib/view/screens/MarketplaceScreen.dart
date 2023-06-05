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
import '../screens/RenteeToolDetails.dart';

class MarketplaceScreen extends StatefulWidget {
  final User user;
  final Tool tool;
  final int selectedIndex;
  const MarketplaceScreen({Key? key, required this.user, required this.tool, required this.selectedIndex});

  @override
  State<MarketplaceScreen> createState() => _marketplaceScreenState();
}

class _marketplaceScreenState extends State<MarketplaceScreen> {
  List<Tool> toolList = <Tool>[];
  String titlecenter = "Loading tools...";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
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
          title: const Text("Tools Available"),
          actions: [
            TextButton.icon(
                onPressed: () {
                  _loadSearchDialog();
                },
                icon: const Icon(Icons.search, color: Colors.white,),
                label: const Text("Search", style: TextStyle(color: Colors.white),),)
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
                                    imageUrl:
                                        "${Config.SERVER}/assets/toolimages/${toolList[index].toolId}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) {
                                    return const Icon(Icons.error);
                                    },
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
                                          Text(df.format(DateTime.parse(toolList[index].toolDate.toString())))
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
                 drawer: MainMenuWidget(user: widget.user, tool: widget.tool),

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
  setState(() {
    curpage = pageno;
    numofpage ??= 1;
  });

  http.get(
    Uri.parse("${Config.SERVER}/php/loadalltools.php?search=$search&pageno=$pageno"),
  ).then((response) {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: null,
    );
    progressDialog.show();
    print(response.body);
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['tools'] != null) {
          print("Success");
          setState(() {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            toolList = List<Tool>.from(
              extractdata['tools'].map((toolJson) => Tool.fromJson(toolJson)),
            );
            titlecenter = "Found";
          });
        } else {
          print("Failed");
          setState(() {
            titlecenter = "No Tools Available";
            toolList.clear();
          });
        }
      }
    } else {
      print("Error");
      setState(() {
        titlecenter = "No Tools Available";
        toolList.clear();
      });
    }

    progressDialog.dismiss();
  });
}


  _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadTools(search, 1);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  _showDetails(int index) async {
    Tool tool = Tool.fromJson(toolList[index].toJson());
    loadSingleRenter(index);
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: null,
    );
    progressDialog.show();
    await Future.delayed(const Duration(seconds: 1));
      if (renter != null) {
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => RenteeToolDetails(
                    user: widget.user, tool: tool, renter: renter)));
      }
   
  }

  loadSingleRenter(int index) async {
    http.post(
        Uri.parse("${Config.SERVER}/php/load_renter.php"),
        body: {"renterid": toolList[index].userId}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        renter = User.fromJson(jsonResponse['data']);
      }
    });
  }
}
