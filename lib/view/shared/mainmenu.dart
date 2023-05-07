import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../screens/DashboardScreen.dart';
import '../screens/NotificationScreen.dart';
import '../screens/ToolList.dart';
import '../screens/profilescreen.dart';
import 'EnterExitRoute.dart';


class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

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
            accountEmail: Text(widget.user.name.toString()),
            currentAccountPicture: const CircleAvatar(
              radius: 30.0,
            ),
            ),
            ListTile(
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context, 
                  EnterExitRoute(
                    exitPage: DashboardScreen(user: widget.user), 
                    enterPage: NotificationScreen(user: widget.user))
                );
              }
            ),
            ListTile(
              title: const Text('Tool List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context, 
                  EnterExitRoute(
                    exitPage: DashboardScreen(user: widget.user), 
                    enterPage: ToolList(user: widget.user))
                );
              }
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context, 
                  EnterExitRoute(
                    exitPage: DashboardScreen(user: widget.user), 
                    enterPage: ProfileScreen(user: widget.user))
                );
              }
            ),
        ],
      ),
    );
  }

}


