import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychat/provider/userpreferences.dart';
import 'package:mychat/services/call_methods.dart';
import 'package:mychat/tabBars/calldata/calls.dart';
import 'package:mychat/tabBars/calldata/pickup_screen.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({@required this.scaffold});

  @override
  Widget build(BuildContext context) {
    final UserPrefs userPrefs = Provider.of<UserPrefs>(context);
    return userPrefs != null && userPrefs.getPhoneNumber != null
        ? StreamBuilder<DocumentSnapshot>(
      stream:
      callMethods.callStream(phoneNumber: userPrefs.getPhoneNumber),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.data != null) {
          CallData callData = CallData.fromMap(snapshot.data.data);
          return !callData.hasDialed?PickupScreen(callData: callData):scaffold;
        }
        return scaffold;
      },
    )
        : Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
