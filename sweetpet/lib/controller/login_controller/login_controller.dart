import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sweetpet/controller/login_controller/UserProvider.dart';
import 'package:sweetpet/controller/login_controller/forget_password.dart';
import 'package:sweetpet/model/userModel.dart';
import 'package:sweetpet/page/chat_page/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweetpet/page/home_page/home_page.dart';
import 'package:provider/provider.dart';
import 'package:sweetpet/constant/uid.dart';

final _firebase = FirebaseAuth.instance;

class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<LoginController> {
  final _form = GlobalKey<FormState>();

  bool _isLogin = true;
  bool _isEmailAndPassword = true;

  bool _isAuthenticating = false;

  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredUsername = '';
  File? _selectedImage;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }

    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
        Get.offAll(() => HomePage());
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        globalUid = userCredentials.user!.uid;
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);

        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
        globalUid = userCredentials.user!.uid;
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _sendEmailLink() async {
    try {
      await _firebase.sendSignInLinkToEmail(
        email: _enteredEmail,
        actionCodeSettings: ActionCodeSettings(
          url: "https://sweetpet.page.link/fantasticfour",
          handleCodeInApp: true,
          iOSBundleId: "com.example.sweetpet.RunnerTests",
          androidPackageName: "com.fantasticfour.sweetpet",
          androidInstallApp: true,
          androidMinimumVersion: "12",
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email link sent! Check your email.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending email link: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 253, 255, 1),
      body: Stack(
        children: [
          // Existing UI
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    width: 300,
                  ),
                  Card(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isLogin ? 'Welcome' : 'Join Us',
                                style: const TextStyle(
                                  fontSize: 75,
                                  fontFamily: 'Hiatus',
                                  color: Color.fromARGB(255, 106, 187, 241),
                                ),
                              ),
                              if (!_isLogin)
                                UserImagePicker(
                                  onPickImage: (pickedImage) {
                                    _selectedImage = pickedImage;
                                  },
                                ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'Enter your email address',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _enteredEmail = newValue!;
                                },
                              ),
                              if (!_isLogin)
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                  ),
                                  enableSuggestions: false,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length < 4) {
                                      return 'Please enter at least 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _enteredUsername = newValue!;
                                  },
                                ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: _isEmailAndPassword
                                      ? 'Password'
                                      : 'Email Code',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return 'Must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _enteredPassword = newValue!;
                                },
                              ),
                              const SizedBox(height: 12),
                              if (_isAuthenticating)
                                const CircularProgressIndicator(),
                              if (!_isAuthenticating && !_isLogin)
                                Container(
                                  width: double
                                      .infinity, // Set the width to match the parent
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          200, 248, 255, 1),
                                      elevation: 0, // Remove button shadow
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Mont',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 106, 187, 241),
                                      ),
                                    ),
                                  ),
                                ),
                              Visibility(
                                visible: _isLogin,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_isLogin && !_isEmailAndPassword) {
                                      // Handle the logic for sending the code
                                      // You can call a function here to send the code
                                    } else {
                                      // Handle the logic for logging in
                                      // You can call a function here to log in
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 106, 187, 241),
                                  ),
                                  child: Text(
                                    _isLogin && !_isEmailAndPassword
                                        ? 'Send Code'
                                        : 'Log In',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              if (_isLogin)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEmailAndPassword =
                                          !_isEmailAndPassword;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 230, 249, 252),
                                    elevation: 0, // Remove button shadow
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Try Another Way to Log In",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Mont',
                                        fontWeight: FontWeight.w900,
                                        color:
                                            Color.fromARGB(255, 90, 189, 255),
                                      ),
                                    ),
                                  ),
                                ),
                              if (_isLogin)
                                Container(
                                  width: double
                                      .infinity, // Set the width to match the parent
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Mont',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 106, 187, 241),
                                      ),
                                    ),
                                  ),
                                ),
                              if (!_isAuthenticating)
                                Container(
                                  width: double
                                      .infinity, // Set the width to match the parent
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                    child: Text(
                                      _isLogin
                                          ? 'New User? Register Now!'
                                          : 'I Already Have An Account',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Mont',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 106, 187, 241),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(
              'sweetpet/assets/images/loginpet.jpg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
