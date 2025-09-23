import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? bio;
  String? gender;
  var timeStamp;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.bio,
    this.gender,
    this.timeStamp,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      bio: map['bio'],
      gender: map['gender'],
      timeStamp: map['timeStamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'gender': gender,
      'timeStamp': FieldValue.serverTimestamp(),
    };
  }
}
