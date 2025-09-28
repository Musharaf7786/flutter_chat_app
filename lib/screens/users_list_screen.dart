import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/room_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';

import 'chatting_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF573894),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Users", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").get().asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF573894)),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return Text("No users found");
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  UserModel userModel = UserModel.fromMap(
                    snapshot.data!.docs[index].data(),
                  );
                  if (userModel.uid == FirebaseAuth.instance.currentUser!.uid) {
                    return SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      color: Color(0xFF573894),
                      child: ListTile(
                        onTap: () {
                          checkAndCreateNewRoom(userModel);
                        },
                        title: Text(
                          userModel.email!,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          userModel.name!,
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  String createRoomId(UserModel toChatUserModel) {
    String roomId = '';

    if (user!.uid.hashCode > toChatUserModel.uid.hashCode) {
      roomId = "${toChatUserModel.uid}_${user!.uid}";
    } else if (user!.uid.hashCode < toChatUserModel.uid.hashCode) {
      roomId = "${user!.uid}_${toChatUserModel.uid!}";
    } else {
      roomId = "${user!.uid}_${toChatUserModel.uid!}";
    }
    return roomId;
  }

  checkAndCreateNewRoom(UserModel toChatUserModel) async {
    String roomId = createRoomId(toChatUserModel);
    CollectionReference roomCollectionReference = FirebaseFirestore.instance
        .collection("rooms");
    DocumentSnapshot documentSnapshot =
        await roomCollectionReference.doc(roomId).get();

    RoomModel roomModel = RoomModel();
    if (documentSnapshot.exists) {
      roomModel = RoomModel.fromMap(
        documentSnapshot.data() as Map<String, dynamic>,
      );
    } else {
      roomModel.peerId = toChatUserModel.uid;
      roomModel.participantsList = [];
      roomModel.participantsList!.add(toChatUserModel.uid);
      roomModel.participantsList!.add(user!.uid);
      await roomCollectionReference.doc(roomId).set(roomModel.toMap());
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChattingScreen(roomModel)),
    );
  }
}
