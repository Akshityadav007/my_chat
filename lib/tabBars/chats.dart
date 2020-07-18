import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/configs/permissions.dart';
import 'package:mychat/floatingButtons/chatfloatbutton.dart';
import 'package:mychat/home.dart';
import 'package:mychat/services/constants.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/tabBars/calldata/call_utilities.dart';

class Chats extends StatefulWidget {
  final String phoneNumber;

  Chats({@required this.phoneNumber});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: databaseMethods.getChatRooms(widget.phoneNumber),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data.documents.length == 0) {
            return Text("No Messages Received");
          } else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                      snapshot.data.documents[index].data["chatRoomId"],
                      snapshot.data.documents[index].data['chatRoomId']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myNumber, ""));
                });
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor:
                HomePage.isSwitched ? Colors.blueGrey : Color(0xff033B8D),
            foregroundColor:
                HomePage.isSwitched ? Colors.white70 : Colors.white,
            child: Center(
              child: Icon(Icons.message),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatFloatButton(),
                ),
              );
            }),
        body: Container(
          child: chatRoomList(),
        ));
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chatRoomId;
  final String chatPersonNumber;

  ChatRoomsTile(this.chatRoomId, this.chatPersonNumber);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(chatPersonNumber),
        subtitle: Text('Tap to see message'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatBluePrint(chatRoomId, chatPersonNumber),
            ),
          );
        },
      ),
//        ],
//      ),
    );
  }
}

class ChatBluePrint extends StatefulWidget {
  final String chatRoomId;
  final String chatPersonNumber;

  ChatBluePrint(this.chatRoomId, this.chatPersonNumber);

  @override
  _ChatBluePrintState createState() => _ChatBluePrintState();
}

class _ChatBluePrintState extends State<ChatBluePrint> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEdittingControlller =
      new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList() {
    return Container(
      padding: EdgeInsets.only(bottom: 60),
      child: StreamBuilder(
          stream: chatMessageStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                          snapshot.data.documents[index].data['message'],
                          snapshot.data.documents[index].data['sendBy'] ==
                              Constants.myNumber);
                    })
                : Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  );
          }),
    );
  }

  sendMessage() {
    if (messageEdittingControlller.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageEdittingControlller.text,
        "sendBy": Constants.myNumber,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageEdittingControlller.clear();
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("This is the phone: ${ChatBluePrint}");
    return MaterialApp(
      home: Scaffold(
        //   resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(widget.chatPersonNumber),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.videocam,
                color: Colors.white,
              ),
              onPressed: () async =>
                  await Permissions.cameraAndMicrophonePermissionsGranted()
                      ? CallUtils.dial(
                          to: widget.chatPersonNumber, context: context)
                      : null,
            ),
            IconButton(
                icon: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                onPressed: null),
            //PopupMenuButton(itemBuilder: null)
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              chatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: SingleChildScrollView(
                    child: Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Type Something",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                controller: messageEdittingControlller,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            iconSize: 30,
                            color: Colors.blue,
                            icon: Icon(Icons.send),
                            onPressed: () {
                              sendMessage();
                            },
                          ),
                          SizedBox(width: 10)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 10, right: isSendByMe ? 10 : 0),
      margin: EdgeInsets.symmetric(vertical: 2),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [Colors.white, Colors.blue]
                : [Colors.green, Colors.white],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
