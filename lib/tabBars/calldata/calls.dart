
class CallData {
  String callerId;
  // String callerName;
  // String callerPic;
  String receiverId;
  // String receiverName;
  // String receiverPic;
  String channelID;
  bool hasDialed;

  CallData({
    this.callerId,
    // this.callerName,
    // this.callerPic,
    this.receiverId,
    // this.receiverName,
    // this.receiverPic,
    this.channelID,
  });

  Map<String,dynamic> toMap(CallData callData){
    Map<String,dynamic> callMap = Map();
    callMap['caller_id'] = callData.callerId;
    callMap['receiver_id'] = callData.receiverId;
    callMap['channel_id'] = callData.channelID;
    return callMap;
  }
  CallData.fromMap(Map callMap){
    this.callerId = callMap["caller_Id"];
    this.receiverId = callMap["receiver_Id"];
    this.channelID = callMap['channel_id'];
  }
  
}
