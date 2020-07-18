import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/configs/permissions.dart';
import 'package:mychat/services/call_methods.dart';
import 'package:mychat/tabBars/calldata/call_screen.dart';
import 'package:mychat/tabBars/calldata/calls.dart';

class PickupScreen extends StatelessWidget {
  final CallData callData;
  final CallMethods callMethods = CallMethods();

  PickupScreen({@required this.callData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Incoming..",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 50),
              Container(
                height: 150,
                width: 150,
                child: Icon(Icons.people),
              ),
              SizedBox(height: 15),
              Text(
                callData.callerId,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.call_end),
                      color: Colors.red,
                      onPressed: () async {
                        await callMethods.endCall(callData: callData);
                      }),
                  SizedBox(width: 25),
                  IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async => await Permissions
                            .cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallScreen(
                                callData: callData,
                              ),
                            ),
                          )
                        : null,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
