import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toolshare_portal/models/tools.dart';
import 'package:toolshare_portal/view/screens/ToolList.dart';
import 'package:toolshare_portal/view/screens/MarketplaceScreen.dart';
import 'package:toolshare_portal/view/shared/EnterExitRoute.dart';
import '../../models/user.dart';
import '../../models/tools.dart';
import '../shared/mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import '../screens/ProfileScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'RegisterToolScreen.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  final Tool tool;
  var selectedIndex = 0;
  DashboardScreen(
      {super.key,
      required this.user,
      required this.tool,
      required this.selectedIndex});

  @override
  State<DashboardScreen> createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<DashboardScreen> {
  List<Tool> toolList = <Tool>[];
  final df = DateFormat('dd/<</yyyy hh:mm a');
  late double screenWidth, resWidth, screenHeight;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var val = 50;
  var numofpage, curpage = 1;
  int numberofresult = 0;

  final List<String> imageList = [
    "assets/images/carousel_image1.png",
    "assets/images/carousel_image2.png",
    "assets/images/carousel_image3.png",
  ];
  final List<String> imageList2 = [
    "assets/images/carousel_featured.png",
    "assets/images/carousel_image4.png",
    "assets/images/carousel_image5.png",
  ];

  @override
  void initState() {
    super.initState();
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

    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("User Dashboard"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text("Welcome back,",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(widget.user.name.toString(),
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
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
                                height: 500, width: 250, fit: BoxFit.fill)
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Featured Tools',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
              ),
              items: imageList2
                  .map((e) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.asset(e,
                                height: 500, width: 250, fit: BoxFit.fill)
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
        drawer: MainMenuWidget(user: widget.user, tool: widget.tool),
      ),
    );
  }
}
