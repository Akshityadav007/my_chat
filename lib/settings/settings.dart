import 'package:flutter/material.dart';

import '../home.dart';

class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: HomePage.isSwitched?ThemeData.dark(): ThemeData(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Settings'),
          ),
        ),
      ),
    );
  }
}
