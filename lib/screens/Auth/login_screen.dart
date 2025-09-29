import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/Auth/register_screen.dart';
import 'package:flutter_chat_app/services/theme_provider_service.dart';
import 'package:flutter_chat_app/widgets/custom_toast_service.dart';
import 'package:flutter_chat_app/widgets/elevated_button.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool showPsw = false;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/Login-PNG.png", width: 330),
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
                        color:
                            themeProvider.isDarkMode
                                ? Colors.white38
                                : Colors.black45,
                      ),

                      label: RichText(
                        text: TextSpan(
                          text: "Email",
                          style: TextStyle(
                            color:
                                themeProvider.isDarkMode
                                    ? Colors.white38
                                    : Colors.black45,
                          ),
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
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color:
                            themeProvider.isDarkMode
                                ? Colors.white38
                                : Colors.black45,
                      ),

                      label: RichText(
                        text: TextSpan(
                          text: "Password",
                          style: TextStyle(
                            color:
                                themeProvider.isDarkMode
                                    ? Colors.white38
                                    : Colors.black45,
                          ),
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

                  Row(
                    children: [
                      Checkbox(
                        activeColor: Color(0xFF573894),
                        value: showPsw,
                        onChanged: (bool? value) {
                          setState(() {
                            showPsw = value ?? false;
                          });
                        },
                      ),
                      Text(
                        "Show Password",
                        style: TextStyle(
                          color: Color(0xFF573894),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MyElevatedButton(
                    text: "Login",
                    backgroundColor: const Color(0xFF573894),
                    borderRadius: 30,
                    onPressed: () {
                      login();
                    },
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Create new account",
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
      ),
    );
  }

  login() {
    String email = emailTextController.text;
    String psw = passwordTextController.text;

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: psw)
        .then((value) async {
          if (!mounted) return;

          ToastService.showSuccess(context, "User Logged In Successfully");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        })
        .catchError((e) {
          if (!mounted) return;
          ToastService.showError(context, "User Login failed $e");
        });
  }
}
