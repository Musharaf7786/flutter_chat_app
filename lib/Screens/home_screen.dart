import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Screens/Auth/login_screen.dart';

import 'package:flutter_chat_app/Screens/users_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // final UserModel userModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF573894),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UsersListScreen()),
          );
        },
        child: Icon(Icons.chat, color: Colors.white),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF573894),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),

            onSelected: (value) {
              // if (value == "profile") {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder:
              //           (context) => ProfileEditScreen(
              //             isComingFromLoginOrSignUp: false,
              //             userModel: widget.userModel,
              //           ),
              //     ),
              //   );
              // } else
              if (value == "logout") {
                showLogOutPopUp();
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  // const PopupMenuItem(value: "profile", child: Text("Profile")),
                  const PopupMenuItem(value: "logout", child: Text("Logout")),
                ],
          ),
        ],
        title: Text("Chats", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  showLogOutPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                "Do you want to logout ?",
                style: TextStyle(
                  color: Color(0xFF573894),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      await deleteDBOnLogOut();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Color(0xFF573894),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: Color(0xFF573894),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteDBOnLogOut() async {
    try {
      final firebaseFireStore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final docRef = firebaseFireStore.collection("users").doc(user.uid);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef.delete();
        print("User data deleted for UID: ${user.uid}");
      } else {
        print("No document found for UID: ${user.uid}");
      }
    } catch (e) {
      print("Error deleting user data: $e");
    }
  }

  // deleteDBOnLogOut() async {
  //   FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     return null;
  //   } else {
  //     await firebaseFireStore.collection("users").doc(user.uid).delete();
  //   }
  // }
}
