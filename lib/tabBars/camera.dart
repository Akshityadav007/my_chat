import 'package:flutter/material.dart';
import 'package:mychat/services/helper.dart';

import '../main.dart';


class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: RaisedButton(
          onPressed: () {
            setState(() {
            HelperFunctions.removeSharedPreferencesData();
            print('loggedOut');
          });
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
          child: Text('Sign Out'),
        ));
  }
}
