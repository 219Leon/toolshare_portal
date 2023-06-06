import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:toolshare_portal/view/screens/ToolList.dart';
import 'package:toolshare_portal/view/screens/MarketplaceScreen.dart';
import 'package:toolshare_portal/view/screens/profilescreen.dart';
import 'package:toolshare_portal/view/screens/DashboardScreen.dart';
import '../../models/tools.dart';
import '../../models/user.dart';

class HomePage extends StatefulWidget {
  final User user;
  final Tool tool;
  var selectedIndex;
  HomePage({super.key, required this.selectedIndex, required this.user, required this.tool});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _tabs = [
      DashboardScreen(user:widget.user, tool:widget.tool, selectedIndex: 0),
      MarketplaceScreen(user:widget.user, tool:widget.tool, selectedIndex: 1),
      ToolList(user:widget.user, tool:widget.tool, selectedIndex: 2),
      ProfileScreen(user:widget.user, tool:widget.tool, selectedIndex: 3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 15),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              curve: Curves.easeOutExpo,
              gap: 10,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              activeColor: Colors.blue,
              tabBorder: Border.all(color: Colors.blueAccent),
              tabActiveBorder: Border.all(),
              tabBorderRadius: 30,
              iconSize: 20,
              tabBackgroundColor: Colors.blue.withOpacity(0.1),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Dashboard',
                ),
                GButton(
                  icon: Icons.store_mall_directory,
                  text: 'Marketplace',
                ),
                GButton(
                  icon: Icons.list_alt,
                  text: 'Tool List',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}