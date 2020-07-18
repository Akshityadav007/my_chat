import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByPhoneNumber(String userPhoneNumber) async {
    return await Firestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: userPhoneNumber)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> createChatRoom(String chatRoomId, chatRoomMap) async {
    return await Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy("time", descending: false)
        .snapshots();
  }

   Stream<QuerySnapshot> getChatRooms(String phoneNumber) {
    return Firestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: phoneNumber)
        .snapshots();
  }
}
