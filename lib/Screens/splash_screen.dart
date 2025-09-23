import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Screens/home_screen.dart';
import '../models/user_model.dart';
import 'Auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Scale (pop-in) animation
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

    // Fade-in animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start repeating animation (pulse effect)
    _controller.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () async {
      if (FirebaseAuth.instance.currentUser == null) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {

        UserModel? userModel;
        userModel = await getUserDetailsFromDb();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userModel: userModel!),
          ),
        );
      }
    });
  }

  Future<UserModel?> getUserDetailsFromDb() async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firebaseFireStore.collection("users").doc(user.uid).get();
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              "assets/images/Splash-Logo.png",
              color: const Color(0xFF573894),
              height: 120,
            ),
          ),
        ),
      ),
    );
  }
}
