import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/widgets/custom_toast_service.dart';
import '../../widgets/elevated_button.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  bool showPsw = false;
  bool showConfirmPsw = false;

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
                  obscureText: !showPsw,
                  obscuringCharacter: '*',
                  controller: passwordTextController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.black45),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPsw = !showPsw;
                        });
                      },
                      icon: Icon(
                        showPsw
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    ),
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
                TextField(
                  buildCounter: (
                    BuildContext context, {
                    int? currentLength,
                    bool? isFocused,
                    int? maxLength,
                  }) {
                    return null;
                  },
                  obscureText: !showConfirmPsw,
                  obscuringCharacter: '*',
                  controller: confirmPasswordTextController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.black45),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showConfirmPsw = !showConfirmPsw;
                        });
                      },
                      icon: Icon(
                        showConfirmPsw
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    ),
                    label: RichText(
                      text: TextSpan(
                        text: "Confirm Password",
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
                  text: "Sign Up",
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
    String confirmPsw = confirmPasswordTextController.text;

    if (email.isEmpty || psw.isEmpty) {
      ToastService.showWarning(context, "Please fill the mandatory fields");
    } else if (confirmPsw != psw) {
      ToastService.showError(context, "Confirm password is incorrect");
    } else {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: psw)
          .then((value) {
            postDetailsToFireStoreDB();
          })
          .catchError((e) {
            if (!mounted) return;
            ToastService.showError(context, "User Account creation failed$e");
          });
    }
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
    if (!mounted) return;
    ToastService.showSuccess(context, "Account created Successfully");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
