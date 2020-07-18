import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/services/call_methods.dart';
import 'package:mychat/services/constants.dart';
import 'package:mychat/tabBars/calldata/call_screen.dart';
import 'package:mychat/tabBars/calldata/calls.dart';


class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({to, context}) async {
    CallData callData = CallData(
        callerId: Constants.myNumber,
        receiverId: to,
        channelID: Random().nextInt(1000).toString());
    bool callMade = await callMethods.makeCall(callData: callData);

    callData.hasDialed = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            callData: callData,
          ),
        ),
      );
    }
  }
}
