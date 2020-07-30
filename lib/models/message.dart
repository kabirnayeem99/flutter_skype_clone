import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String recieverId;
  String type;
  String message;
  FieldValue timeStamp;
  String photoUrl;

  Message({
    this.senderId,
    this.recieverId,
    this.type,
    this.message,
    this.timeStamp,
  });

  Message.imageMessage({
    this.senderId,
    this.recieverId,
    this.type,
    this.message,
    this.timeStamp,
    this.photoUrl,
  });

  Map toMap() {
    /*
    Creating a map from an message object
    turning each element into a map value
     */
    var map = Map<String, dynamic>();
    map["senderId"] = this.senderId;
    map["recieverId"] = this.recieverId;
    map["type"] = this.type;
    map["message"] = this.message;
    map["timeStamp"] = this.timeStamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    /*
    turn the map into a messsage object.
     */
    Message _message = Message();
    _message.senderId = map["senderId"];
    _message.recieverId = map["recieverId"];
    _message.message = map["message"];
    _message.type = map["type"];
    _message.timeStamp = map["timeStamp"];
    return _message;
  }
}
