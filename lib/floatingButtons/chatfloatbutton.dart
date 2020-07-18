import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mychat/services/constants.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/tabBars/chats.dart';
import '../home.dart';

class ChatFloatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: HomePage.isSwitched ? ThemeData.dark() : ThemeData(),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor:
              HomePage.isSwitched ? Colors.blueGrey : Colors.lightBlue,
          foregroundColor: HomePage.isSwitched ? Colors.white70 : Colors.white,
          child: Icon(Icons.search),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen())),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Select contact'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text('No Contacts saved'),
          ),
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  bool searchComplete = false;

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController phoneNumberSearchController = TextEditingController();
  QuerySnapshot searchSnapshot;
  FlutterToast flutterToast;



  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  initiateSearch() async {
    if (phoneNumberSearchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .getUserByPhoneNumber(phoneNumberSearchController.text)
          .then((val) {
        searchSnapshot = val;
        setState(() {
          isLoading = false;
          searchComplete = true;
        });
      });
    }
    else{
      _showPhoneToast();
    }
    phoneNumberSearchController.clear();
  }

  Widget searchList() {
    return searchSnapshot != null
        ? isLoading
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.builder(
                      itemCount: searchSnapshot.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = searchSnapshot.documents[index];
                        return searchTile(
                          ds["phoneNumber"],
                        );
                      })
                ],
              )
        : Container();
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.black12,
      ),
      child: Text("You can't send message to yourself"),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }
  _showPhoneToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.black12,
      ),
      child: Text("Enter a valid number"),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  createChatRoomAndStartConversation(otherUserPhoneNumber) {
    if (otherUserPhoneNumber != Constants.myNumber) {
      String chatRoomId =
          getChatRoomId(otherUserPhoneNumber, Constants.myNumber);
      List<String> users = [otherUserPhoneNumber, Constants.myNumber];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatBluePrint(chatRoomId, otherUserPhoneNumber),
        ),
      );
    } else {
      _showToast();
      print(
          'You can\'t send message to yourself \n This is other user: $otherUserPhoneNumber \n This is you: ${Constants.myNumber}');
    }
  }

  Widget searchTile(String otherPhoneNumber) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(otherPhoneNumber),
            ],
          ),
          Spacer(),
          IconButton(icon: Icon(Icons.perm_contact_calendar), onPressed: null),
          //  Padding(padding: EdgeInsets.only(right: 10)),
          RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue,
            onPressed: () => {
              createChatRoomAndStartConversation(otherPhoneNumber),
            },
            child: Text('Message'),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    print("This is String a & b: $a and $b ");
    try {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        return "$b\_$a";
      } else {
        return "$a\_$b";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: HomePage.isSwitched ? ThemeData.dark() : ThemeData(),
      home: Scaffold(
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: myHeight / 15),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.lightBlueAccent),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: phoneNumberSearchController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Search by number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                        )
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.lightBlueAccent),
                      child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            initiateSearch();
                          }),
                    )
                  ],
                ),
              ),
              searchList()
            ],
          ),
        ),
      ),
    );
  }
}
