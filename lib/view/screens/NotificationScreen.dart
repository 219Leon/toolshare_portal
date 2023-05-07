import 'package:flutter/material.dart';

import '../../models/user.dart';

class NotificationScreen extends StatefulWidget{
  final User user;
  const NotificationScreen({super.key, required this.user});
  @override
  State<StatefulWidget> createState() => _NotificationState();

}

class _NotificationState extends State<NotificationScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}