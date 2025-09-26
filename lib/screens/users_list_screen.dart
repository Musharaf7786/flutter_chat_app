import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';

import 'chatting_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
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
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      color: Color(0xFF573894),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChattingScreen(),
                            ),
                          );
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
}
