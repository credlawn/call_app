import 'package:flutter/material.dart';

class Dashboard{

  IconData? icon;
  String?title;
  String? count;
  Color? color;

  Dashboard({this.title,this.icon,this.count,this.color});

  static List<Dashboard> dashboardList = [
    Dashboard(title: 'Total Leads',count: '10',icon: Icons.leaderboard_rounded,color: Colors.red),
    Dashboard(title: 'Today Leads',count: '50',icon: Icons.today,color: Colors.cyan),
    Dashboard(title: 'Total Calls',count: '40',icon: Icons.call_missed_outgoing_sharp,color: Colors.green),
    Dashboard(title: 'Today Calls',count: '50',icon: Icons.call_missed,color: Colors.deepPurple),
  ];
}