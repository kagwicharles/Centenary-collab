import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  List<Tab> tabs;
  List<Widget> tabWidgets;
  String title;

  TabWidget(
      {required this.tabs, required this.title, required this.tabWidgets});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: tabs),
          title: Text(title),
        ),
        body: TabBarView(children: tabWidgets),
      ),
    );
  }
}
