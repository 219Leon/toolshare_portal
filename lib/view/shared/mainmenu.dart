import 'package:flutter/material.dart';
import 'package:toolshare_portal/view/screens/HomeScreen.dart';
import 'package:toolshare_portal/view/screens/ReceiptScreen.dart';
import '../../models/user.dart';
import '../../models/tools.dart';
import 'EnterExitRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toolshare_portal/config.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  final Tool tool;
  const MainMenuWidget({super.key, required this.user, required this.tool});
  
  get transaction => null;

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
            accountName: Text(widget.user.name.toString()),
            accountEmail: Text("User ID: U-${widget.user.id.toString().padLeft(5, '0')}"),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundImage: CachedNetworkImageProvider(
                widget.user.id != null
                    ? "${Config.SERVER}/assets/profileimages/${widget.user.id}.jpg"
                    : "${Config.SERVER}/assets/profileimages/imageunknown.jpg",
              ),
            ),
          ),
          ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: HomePage(
                          user: widget.user,
                          tool: widget.tool,
                          selectedIndex: 0,
                        ),
                        enterPage: HomePage(
                          user: widget.user,
                          tool: widget.tool,
                          selectedIndex: 0,
                        )));
              }),
          ListTile(
              title: const Text('Tool Marketplace'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: HomePage(
                          user: widget.user,
                          tool: widget.tool,
                          selectedIndex: 0,
                        ),
                        enterPage: HomePage(
                          user: widget.user,
                          tool: widget.tool,
                          selectedIndex: 1,
                        )));
              }),
          ListTile(
              title: const Text('Tool List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: HomePage(
                          user: widget.user,
                          tool: widget.tool,
                          selectedIndex: 0,
                        ),
                        enterPage: HomePage(
                          user: widget.user,
                          tool: widget.tool,
                          selectedIndex: 2,
                        )));
              }),
          ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    EnterExitRoute(
                        exitPage: HomePage(
                          user: widget.user,
                          tool: widget.tool,
                          selectedIndex: 0,
                        ),
                        enterPage: HomePage(
                          user: widget.user,
                          tool: widget.tool,
                          selectedIndex: 3,
                        )));
              }),
          
        ],
      ),
    );
  }
}
