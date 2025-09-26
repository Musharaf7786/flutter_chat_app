import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Screens/Auth/login_screen.dart';
import 'package:flutter_chat_app/Screens/home_screen.dart';
import 'package:flutter_chat_app/Screens/profile_edit_screen.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../widgets/elevated_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/register.png", width: 330),
                SizedBox(height: 20),
                TextField(
                  buildCounter: (
                    BuildContext context, {
                    int? currentLength,
                    bool? isFocused,
                    int? maxLength,
                  }) {
                    return null;
                  },
                  controller: emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.black45,
                    ),

                    label: RichText(
                      text: TextSpan(
                        text: "Email",
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF573894),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF573894),
                        width: 2,
                      ),
                    ),
                    errorMaxLines: 2,
                  ),
                  maxLines: 1,
                ),

                SizedBox(height: 20),
                TextField(
                  buildCounter: (
                    BuildContext context, {
                    int? currentLength,
                    bool? isFocused,
                    int? maxLength,
                  }) {
                    return null;
                  },
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: passwordTextController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.black45),

                    label: RichText(
                      text: TextSpan(
                        text: "Password",
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF573894),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF573894),
                        width: 2,
                      ),
                    ),
                    errorMaxLines: 2,
                  ),
                  maxLines: 1,
                ),

                SizedBox(height: 20),
                MyElevatedButton(
                  text: "Register",
                  backgroundColor: const Color(0xFF573894),
                  borderRadius: 30,
                  onPressed: () {
                    registerWithEmail();
                  },
                ),

                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Already have account?",
                    style: TextStyle(
                      color: Color(0xFF573894),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  registerWithEmail() {
    String email = emailTextController.text;
    String psw = passwordTextController.text;

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: psw)
        .then((value) {
          // goToProfileEditScreen();
          postDetailsToFireStoreDB();
        })
        .catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User Account creation failed$e")),
          );
        });
  }

  goToProfileEditScreen() {
    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();
    userModel.uid = user?.uid;
    userModel.email = user?.email;
    userModel.name = user?.email!.split("@")[0];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProfileEditScreen(
              isComingFromLoginOrSignUp: true,
              userModel: userModel,
            ),
      ),
    );
  }

  postDetailsToFireStoreDB() async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();
    userModel.uid = user?.uid;
    userModel.email = user?.email;
    userModel.name = user?.email!.split("@")[0];

    await firebaseFireStore
        .collection("users")
        .doc(user?.uid)
        .set(userModel.toMap());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Account created Successfully")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
