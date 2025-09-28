import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomModel {
  String? senderId;
  String? peerId;
  var timeStamp;
  String? lastMessage;
  List? participantsList = [];
  String? roomId;

  RoomModel({
    this.senderId,
    this.peerId,
    this.timeStamp,
    this.lastMessage,
    this.participantsList,
    this.roomId,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      senderId: map['senderId'],
      peerId: map['peerId'],
      timeStamp: map['timeStamp'],
      lastMessage: map['lastMessage'],
      participantsList: map['participantsList'],
      roomId: map['roomId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
      'participantsList': participantsList,
      'lastMessage': "",
      'peerId': peerId,
      'roomId': roomId,
    };
  }
}
