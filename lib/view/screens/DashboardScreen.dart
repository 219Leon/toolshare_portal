import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/view/screens/RegisterToolScreen.dart';
import 'package:toolshare_portal/view/screens/ToolList.dart';
import 'package:toolshare_portal/view/screens/MarketplaceScreen.dart';
import 'package:toolshare_portal/view/screens/RegisterToolScreen.dart';
import '../../models/user.dart';
import '../../models/tools.dart';
import 'package:toolshare_portal/config.dart';
import '../shared/mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import '../screens/ProfileScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  final Tool tool;
  const DashboardScreen({super.key, required this.user, required this.tool});

  @override
  State<DashboardScreen> createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<DashboardScreen> {
  List<Tool> toolList = <Tool>[];
  String titlecenter = "Loading tools...";
  final df = DateFormat('dd/<</yyyy hh:mm a');
  late double screenWidth, resWidth, screenHeight;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var renter;
  var color;
  var val = 50;
  var numofpage, curpage = 1;
  int numberofresult = 0;
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Dashboard";

  final List<String> imageList = [
    "assets/images/carousel_image1.png",
    "assets/images/carousel_image2.png",
    "assets/images/carousel_image3.png",
  ];

  @override
  void initState() {
    super.initState();
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
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("User Dashboard"),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20,),
              const Text("Welcome back,",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(widget.user.username.toString(),
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              CarouselSlider(
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                ),
                items: imageList
                    .map((e) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.asset(e,
                                  width: 300, height: 150, fit: BoxFit.cover)
                            ],
                          ),
                        ))
                    .toList(),
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
                    drawer: MainMenuWidget(user: widget.user, tool: widget.tool),

        ),
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
