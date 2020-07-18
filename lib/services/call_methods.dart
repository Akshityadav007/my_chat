import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychat/services/constants.dart';
import 'package:mychat/tabBars/calldata/calls.dart';

class CallMethods{
  final CollectionReference callCollection = Firestore.instance.collection(Constants.CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String phoneNumber}) => callCollection.document(phoneNumber).snapshots();

  Future<bool>makeCall({CallData callData}) async{
    try{
      callData.hasDialed = true;
      Map<String,dynamic> hasDialledMap = callData.toMap(callData);
      callData.hasDialed= false;
      Map<String,dynamic> hasNotDialledMap = callData.toMap(callData);
      await callCollection.document(callData.callerId).setData(hasDialledMap);
      await callCollection.document(callData.receiverId).setData(hasNotDialledMap);
      return true;
    }
    catch(e){
      print("Call Collection not made due to: "+e);
      return false;
    }
  }

  Future<bool> endCall({CallData callData}) async {
   try{
     await callCollection.document(callData.callerId).delete();
     await callCollection.document(callData.receiverId).delete();
     return true;
   }
   catch(e){
     print("Could not end the call due to: "+e);
     return false;
   }
  }
}