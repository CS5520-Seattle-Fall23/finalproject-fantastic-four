/*
  The following Dart code represents a Flutter application for user authentication
  using Firebase. The code includes a login screen with email/password and email
  link authentication options. It features form validation, user image upload, and
  navigation to the home page upon successful authentication. The UI dynamically
  adjusts based on whether the user is logging in or signing up.

  Lint Rule Exclusion:
  - The 'use_build_context_synchronously' lint rule is ignored to suppress warnings.

  Key Components:
  - FirebaseAuth, FirebaseFirestore, and FirebaseStorage instances for authentication.
  - LoginController StatefulWidget to manage login state.
  - _AuthScreenState as the state class for LoginController.
  - GlobalKey<FormState> for managing the form state.

  Features:
  - Authentication logic based on login state and email/password or email link.
  - Form validation and saving of user input.
  - User image upload to Firebase Storage during registration.
  - Snackbar feedback for authentication success or failure.
  - Dynamic UI adjustments based on login/signup state.

  Note: This code assumes the existence of certain dependencies, such as Get package
  for navigation and constant values (e.g., globalUid) for tracking user information.

  Author: [Xu Tan]
  Date: [12/8/2023]
*/
// ignore_for_file: use_build_context_synchronously
// Ignoring the use_build_context_synchronously lint rule to suppress warnings.
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  const LoginController({super.key});

  @override
  State<LoginController> createState() {
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
      body: Center(
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
                width: 200,
                // child: Image.asset('assets/images/chat.png'),
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
                            key: const Key('emailField'),
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
                            key: const Key('passwordField'),
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long';
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
                          if (!_isAuthenticating)
                            ElevatedButton(
                              key: const Key('loginButton'),
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(200, 248, 255, 1),
                                elevation: 0, // Remove button shadow
                              ),
                              child: Text(
                                _isLogin ? 'Log In' : 'Sign Up',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromARGB(255, 106, 187, 241),
                                ),
                              ),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'New User? Register Now!'
                                    : 'I Already Have An Account',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 106, 187, 241),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
