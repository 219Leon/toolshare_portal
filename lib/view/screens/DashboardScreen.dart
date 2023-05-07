import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/view/screens/ToolList.dart';
import '../../models/user.dart';
import '../shared/mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import '../screens/MarketplaceScreen.dart';
import '../screens/ProfileScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<DashboardScreen> {
  List<Tool> toolList = <Tool>[];
  String titlecenter = "Loading tools...";
  final df = DateFormat('dd/<</yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var renter;
  var color;
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
    tabchildren = const [
      DashboardScreen(),
      MarketplaceScreen(),
      ToolList(user: null),
      ProfileScreen(user: null),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Dashboard"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Row(
                children: [

                ],
              ),
            ),
            const SizedBox(height: 10),
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
                                width: 400, height: 200, fit: BoxFit.cover)
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.house),
              label: "Dashboard"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.store_mall_directory),
              label: "Tool Marketplace"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt),
              label: "Tool List"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person),
              label: "Account"),  
          ],
        ),
        
      ),
    );
  }
  void onTabTapped(int value){
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0){
        maintitle = "Dashboard";
      } else if (_currentIndex == 1){
        maintitle = "Tool Marketplace";
      } else if (_currentIndex == 2){
        maintitle = "Tool List";
      } else if (_currentIndex == 3){
        maintitle = "Account";
      }
    });
  }
}
