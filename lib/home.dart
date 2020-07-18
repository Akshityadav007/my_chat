import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mychat/provider/userpreferences.dart';
import 'package:mychat/services/constants.dart';
import 'package:mychat/services/helper.dart';
import 'file:///C:/Users/benak/AndroidStudioProjects/my_chat/lib/settings/settings.dart';
//import 'package:mychat/tabBars/calldata/calls.dart';
import 'package:mychat/tabBars/calldata/pickup_layout.dart';
import 'package:mychat/tabBars/camera.dart';
import 'package:mychat/tabBars/chats.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';

class Options {
  static const String NewGroup = 'New Group';
  static const String NewBroadCast = 'New Broadcast';
  static const String Settings = 'Settings';

  static const List<String> options = <String>[
    NewGroup,
    NewBroadCast,
    Settings
  ];
}

class HomePage extends StatefulWidget {
  static bool isSwitched = false;


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isConnected = false;

  TabController _tabController;
  ScrollController _scrollController;
  StreamSubscription connectivitySubscription;
  ConnectivityResult oldRes;

  void optionAction(String options) {
    if (options == Options.NewGroup) {} else
    if (options == Options.NewBroadCast) {} else
    if (options == Options.Settings) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => settings(),
          ));
    }
  }

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 1);
    _scrollController = new ScrollController();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult resNow) {
      if (resNow != ConnectivityResult.none) {
        setState(() {
          isConnected = true;
        });
        print("Connected");
      } else {
        setState(() {
          isConnected = false;
        });
        print("not Connected");
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getUserInfo();
    });
    super.initState();
  }

  getUserInfo() async {
    Constants.myNumber = await HelperFunctions.getPhoneNumberSharedPreference();
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  UserPrefs userPrefs;

  @override
  Widget build(BuildContext context) {
    userPrefs = Provider.of<UserPrefs>(context);
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double cameraWidth = width / 24;
    double yourWidth = (width - cameraWidth) / 6;

    return Theme(
      data: HomePage.isSwitched ? ThemeData.dark() : ThemeData(),
      child: PickupLayout(
        scaffold: Scaffold(
            body: Container(
              height: height,
              width: width,
              child: SafeArea(
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context,
                      bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(floating: true,
                        pinned: true,
                        centerTitle: false,
                        snap: true,
                        backgroundColor:
                        HomePage.isSwitched ? Colors.blueGrey : Color(0xff033B8D ),
                        expandedHeight: height/6,
                        actions: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 2.0, top: 20.0),
                            child: isConnected ? Text('online') : Text('offline'),
                          ),
                          Switch(
                            value: HomePage.isSwitched,
                            onChanged: (val) {
                              setState(() {
                                HomePage.isSwitched = val;
                              });
                            },
                            activeTrackColor: Colors.blue[100],
                            activeColor: Colors.grey,
                          ),
                          Padding(padding: EdgeInsets.only(right: 2.0)),
                          PopupMenuButton(
                              onSelected: optionAction,
                              itemBuilder: (BuildContext context) {
                                return Options.options.map((String optionChosen) {
                                  return PopupMenuItem<String>(
                                    value: optionChosen,
                                    child: Text(optionChosen),
                                  );
                                }).toList();
                              }),
                        ],

                        title: Text(
                          'GET 2',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        bottom: TabBar(
                            indicatorWeight: 3.0,
                            indicatorColor: Colors.grey,
                            controller: _tabController,
                            isScrollable: true,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal:
                                (width - (cameraWidth + yourWidth * 3))/0.8),
                            tabs: <Widget>[
                              Container(
                                child: Tab(
                                  child: Icon(Icons.camera),
                                ),
                                width: cameraWidth,
                              ),Container(
                                width: yourWidth,
                                child: Tab(
                                  text: 'CHATS',
                                ),
                              ),

//                              Container(
//                                width: yourWidth,
//                                child: Tab(
//                                  text: 'STATUS',
//                                ),
//                              ),
//                              Container(
//                                width: yourWidth,
//                                child: Tab(
//                                  text: 'CALLS',
//                                ),
//                              ),
                            ]),
                      )
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      Camera(),
                      userPrefs.getPhoneNumber == "" ? CircularProgressIndicator() : Chats(phoneNumber: userPrefs.getPhoneNumber,),

//                      Status(),
//                      Calls(),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
