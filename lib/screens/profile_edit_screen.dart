import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/widgets/elevated_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    super.key,
    required this.isComingFromLoginOrSignUp,
    required this.userModel,
  });

  final bool isComingFromLoginOrSignUp;
  final UserModel userModel;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final bioTextController = TextEditingController();
  String? selectedGender;
  File? file;

  Uint8List? imageBytes;
  final nameController = TextEditingController();

  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfileImage();
    if (!widget.isComingFromLoginOrSignUp) {
      _fetchUserDetailsFromDb();
    } else {
      nameController.text = widget.userModel.name ?? "";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  void _loadProfileImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? base64Image = preferences.getString("profile_image");

    if (base64Image != null) {
      setState(() {
        imageBytes = base64Decode(base64Image);
      });
    }
  }

  Future<void> _fetchUserDetailsFromDb() async {
    UserModel? fetchedUser = await getUserDetailsFromDb();

    if (fetchedUser != null) {
      setState(() {
        userModel = fetchedUser;
        bioTextController.text = fetchedUser.bio ?? "";
        nameController.text = fetchedUser.name ?? "";
        selectedGender = fetchedUser.gender ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.isComingFromLoginOrSignUp,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF573894),

        title: Text("Profile", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Stack(
                  children: [
                    imageBytes == null
                        ? Icon(
                          Icons.account_circle,
                          color: Colors.black45,
                          size: 150,
                        )
                        : Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(imageBytes!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    Positioned(
                      top: 95,
                      left: 100,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF573894),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showProfileImageBottomSheet(context);
                          },
                          icon: Icon(Icons.edit_rounded, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
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
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // hintText: "Name",
                    label: Text("Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFF573894),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
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
                SizedBox(
                  height: 200,

                  child: TextField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    buildCounter: (
                      BuildContext context, {
                      int? currentLength,
                      bool? isFocused,
                      int? maxLength,
                    }) {
                      return null;
                    },
                    controller: bioTextController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // hintText: "Bio",
                      label: Text("Bio"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF573894),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF573894),
                          width: 2,
                        ),
                      ),
                      // errorMaxLines: 2,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  iconEnabledColor: Color(0xFF573894),

                  value: selectedGender,
                  hint: const Text("Select Gender"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xFF573894),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                !widget.isComingFromLoginOrSignUp
                    ? MyElevatedButton(
                      text: "Save",
                      onPressed: () {
                        saveButtonClick(widget.userModel, context);
                      },
                    )
                    : Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyElevatedButton(
                          text: "Save",
                          onPressed: () {
                            // saveButtonClick(widget.userModel, context);
                            postDetailsToFireStoreDBOnSave(
                              widget.userModel,
                              context,
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        MyElevatedButton(
                          // backgroundColor: Colors.transparent,
                          text: "Skip",
                          onPressed: () {
                            postDetailsToFireStoreDBOnSkip(
                              widget.userModel,
                              context,
                            );
                          },
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showProfileImageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          // color: Color(0xFF573894),
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              file != null
                  ? Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          file = null;
                          Navigator.pop(context);
                          setState(() {});
                        },
                        icon: Icon(Icons.delete, color: Color(0xFF573894)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Remove",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF573894),
                        ),
                      ),
                    ],
                  )
                  : SizedBox.shrink(),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      pickOrCaptureProfileImage(true);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.camera_alt, color: Color(0xFF573894)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF573894),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      pickOrCaptureProfileImage(false);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.upload, color: Color(0xFF573894)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Upload",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF573894),
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

  pickOrCaptureProfileImage(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (photo != null) {
      file = File(photo.path);
      final bytes = await file!.readAsBytes();
      String base64Image = base64Encode(bytes);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("profile_image", base64Image);
      setState(() {});
    }
  }

  saveButtonClick(UserModel userModel, BuildContext context) async {
    Map<String, dynamic> map = {};
    map['name'] = nameController.text;
    map['bio'] = bioTextController.text;
    map['gender'] = selectedGender;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(map);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  postDetailsToFireStoreDBOnSave(
    UserModel userModel,
    BuildContext context,
  ) async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;

    userModel.uid = user?.uid;
    userModel.email = user?.email;
    userModel.name = nameController.text;
    userModel.bio = bioTextController.text;
    userModel.gender = selectedGender;

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

  postDetailsToFireStoreDBOnSkip(
    UserModel userModel,
    BuildContext context,
  ) async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;

    userModel.uid = user?.uid;
    userModel.email = user?.email;
    userModel.name = nameController.text;

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

  Future<UserModel?> getUserDetailsFromDb() async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    } else {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firebaseFireStore.collection("users").doc(user.uid).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    }
  }

  /// TO UPDATE THE PROFILE DETAILS
  updateProfile() async {
    Map<String, dynamic> map = {};
    if (file != null) {
      String url = await uploadImage();
      map['profilePic'] = url;
    }
    map['name'] = nameController.text;
    map['bio'] = bioTextController.text;
    map['gender'] = selectedGender;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(map);
  }

  /// TO STORE THE PROFILE IMAGE IN FIREBASE STORAGE
  Future<String> uploadImage() async {
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child('profile')
        .child(
          '${FirebaseAuth.instance.currentUser!.uid}_${basename(file!.path)}',
        )
        .putFile(file!);
    return snapshot.ref.getDownloadURL();
  }
}
