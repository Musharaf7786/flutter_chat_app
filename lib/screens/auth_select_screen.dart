import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/Auth/login_screen.dart';
import 'package:flutter_chat_app/screens/Auth/register_screen.dart';
import 'package:flutter_chat_app/widgets/elevated_button.dart';

import '../services/google_services.dart';
import '../widgets/custom_toast_service.dart';
import 'home_screen.dart';

class AuthSelectScreen extends StatefulWidget {
  const AuthSelectScreen({super.key});

  @override
  State<AuthSelectScreen> createState() => _AuthSelectScreenState();
}

class _AuthSelectScreenState extends State<AuthSelectScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Splash-Logo.png",
              color: Color(0xFF573894),
            ),
            SizedBox(height: 50),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF573894),
                  ),
                  onPressed: () {
                    signInWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/google_logo.png",
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Continue with Google",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
            SizedBox(height: 10),
            MyElevatedButton(
              backgroundColor: Color(0xFF573894),
              borderRadius: 30,
              text: "Sign Up",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Color(0xFF573894)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userCredentials = await GoogleSignInServices.signInWithGoogle();
      if (!mounted) return;
      if (userCredentials != null) {
        if (!mounted) return;
        ToastService.showSuccess(context, "User Logged in successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.showError(context, "$e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
