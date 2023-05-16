import 'package:flutter/material.dart';
import 'package:toolshare_portal/view/screens/MarketplaceScreen.dart';
import 'package:toolshare_portal/view/screens/RentPayment.dart';
import '../../models/user.dart';
import '../../models/tools.dart';
import '../screens/DashboardScreen.dart';
import '../screens/detailscreen.dart';
import '../screens/ToolList.dart';
import '../screens/profilescreen.dart';
import 'EnterExitRoute.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  final Tool tool;
  const MainMenuWidget({super.key, required this.user, required this.tool});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.email.toString()),
            accountEmail: Text(widget.user.username.toString()),
            currentAccountPicture: const CircleAvatar(
              radius: 30.0,
            ),
          ),
          ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: DashboardScreen(
                          user: widget.user,
                          tool: widget.tool,
                        ),
                        enterPage: DashboardScreen(
                          user: widget.user,
                          tool: widget.tool,
                        )));
              }),
                    ListTile(
              title: const Text('Tool Marketplace'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: DashboardScreen(
                          user: widget.user,
                          tool: widget.tool,
                        ),
                        enterPage: MarketplaceScreen(
                          user: widget.user,
                          tool: widget.tool,
                        )));
              }),
                    ListTile(
              title: const Text('Rent Payment'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: DashboardScreen(
                          user: widget.user,
                          tool: widget.tool,
                        ),
                        enterPage: RentPayment(
                          user: widget.user,
                          renter: widget.user,
                          tool: widget.tool,
                        )));
              }),          
          ListTile(
              title: const Text('Tool List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: DashboardScreen(
                          user: widget.user,
                          tool: widget.tool,
                        ),
                        enterPage: ToolList(
                          user: widget.user,
                          tool: widget.tool,
                        )));
              }),
          ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: DashboardScreen(
                          user: widget.user,
                          tool: widget.tool,
                        ),
                        enterPage: ProfileScreen(
                          user: widget.user,
                          tool: widget.tool,
                        )));
              }),
        ],
      ),
    );
  }
}
