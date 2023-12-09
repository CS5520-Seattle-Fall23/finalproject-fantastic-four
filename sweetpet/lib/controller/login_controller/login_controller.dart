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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetpet/controller/login_controller/forget_password.dart';
import 'package:sweetpet/page/chat_page/user_image_picker.dart';
import 'package:sweetpet/page/home_page/home_page.dart';
import 'package:sweetpet/constant/uid.dart';

// Creating an instance of FirebaseAuth for authentication.
final _firebase = FirebaseAuth.instance;

// LoginController is a StatefulWidget as it needs to maintain state.
class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  State<LoginController> createState() {
    // Creating the state for LoginController.
    return _AuthScreenState();
  }
}

// _AuthScreenState is the state class for LoginController.
class _AuthScreenState extends State<LoginController> {
  // GlobalKey for managing the state of the form.
  final _form = GlobalKey<FormState>();

  // Boolean flags to track the login state and authentication method.
  bool _isLogin = true;
  bool _isEmailAndPassword = true;
  bool _isAuthenticating = false;

  // Variables to store user input.
  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredUsername = '';
  File? _selectedImage;

  String _buttonText = 'Log In';

  // Method to handle form submission.
  void _submit() async {
    // Validate the form.
    final isValid = _form.currentState!.validate();

    // Check if the form is not valid or additional conditions are not met.
    if (!isValid || (!_isLogin && _selectedImage == null)) {
      return;
    }

    // Save the form data.
    _form.currentState!.save();

    try {
      // Set the flag to indicate authentication is in progress.
      setState(() {
        _isAuthenticating = true;
      });

      // Perform authentication based on the login state.
      if (_isLogin) {
        if (_isEmailAndPassword) {
          // Sign in with email and password.
          final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword,
          );
          // Set the globalUid with the user's UID.
          globalUid = userCredentials.user!.uid;
        } else {
          // Send an email link for authentication.
          await _sendEmailLink();
        }
      } else {
        // Create a new user with email and password.
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        // Store user image in Firebase Storage.
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);

        // Get the download URL of the stored image.
        final imageUrl = await storageRef.getDownloadURL();

        // Store user information in Firestore.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });

        // Set the globalUid with the user's UID.
        globalUid = userCredentials.user!.uid;
      }

      // Navigate to the HomePage after successful authentication.
      Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (error) {
      // Handle FirebaseAuth exceptions and show a SnackBar with the error message.
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
    } finally {
      // Set the flag to indicate authentication is complete.
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  // Method to send an email link for authentication.
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
      // Show a SnackBar when the email link is successfully sent.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email link sent! Check your email.'),
        ),
      );
    } catch (error) {
      // Show a SnackBar if there is an error sending the email link.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending email link: $error'),
        ),
      );
    }
  }

  // Build method for the UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting the background color of the scaffold.
      backgroundColor: Color.fromRGBO(238, 253, 255, 1),
      // Creating a stack to overlay widgets.
      body: Stack(
        children: [
          // Existing UI
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // Container for spacing at the top.
                    margin: const EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    width: 300,
                  ),
                  // Card for containing the form.
                  Card(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          // GlobalKey assigned to the form.
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Displaying a welcome message or signup message based on the login state.
                              Text(
                                _isLogin ? 'Welcome' : 'Join Us',
                                style: const TextStyle(
                                  fontSize: 75,
                                  fontFamily: 'Hiatus',
                                  color: Color.fromARGB(255, 106, 187, 241),
                                ),
                              ),
                              // Widget for picking user image (shown only during signup).
                              if (!_isLogin)
                                UserImagePicker(
                                  onPickImage: (pickedImage) {
                                    _selectedImage = pickedImage;
                                  },
                                ),
                              // TextFormField for entering email address.
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'Enter your email address',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  // Validation for a valid email address.
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  // Save the entered email address.
                                  _enteredEmail = newValue!;
                                },
                              ),
                              // TextFormField for entering username (shown only during signup).
                              if (!_isLogin)
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                  ),
                                  enableSuggestions: false,
                                  validator: (value) {
                                    // Validation for a valid username.
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length < 4) {
                                      return 'Please enter at least 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    // Save the entered username.
                                    _enteredUsername = newValue!;
                                  },
                                ),
                              // TextFormField for entering password or email code based on the state.
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: _isEmailAndPassword
                                      ? 'Password'
                                      : 'Email Code',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  // Validation for password length.
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return 'Must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  // Save the entered password or email code.
                                  _enteredPassword = newValue!;
                                },
                              ),
                              const SizedBox(height: 12),
                              // Display a loading indicator during authentication.
                              if (_isAuthenticating)
                                const CircularProgressIndicator(),
                              // Display a "Sign Up" button only during signup.
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
                              // Display "Send Code" or "Log In" button based on the state.
                              Visibility(
                                visible: _isLogin,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_isLogin && !_isEmailAndPassword) {
                                      // Confirm the link is a sign-in with email link.
                                      if (FirebaseAuth.instance
                                          .isSignInWithEmailLink(
                                              _enteredEmail)) {
                                        try {
                                          // The client SDK will parse the code from the link for you.
                                          final userCredential =
                                              await FirebaseAuth.instance
                                                  .signInWithEmailLink(
                                            email: _enteredEmail,
                                            emailLink:
                                                'https://sweetpet-e5c86.firebaseapp.com',
                                          );

                                          // You can access the new user via userCredential.user.
                                          final emailAddress =
                                              userCredential.user?.email;

                                          print(
                                              'Successfully signed in with email link!');

                                          // Update the button text
                                          setState(() {
                                            _buttonText = 'Verify Code';
                                          });

                                          // Update the state if necessary
                                          setState(() {
                                            // Perform any state updates here
                                          });
                                        } catch (error) {
                                          print(
                                              'Error signing in with email link.');
                                        }
                                      }
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

                              // Toggle button for trying another way to log in (shown only during login).
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
                              // "Forgot Password" button (shown only during login).
                              if (_isLogin)
                                Container(
                                  width: double
                                      .infinity, // Set the width to match the parent
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigate to the ForgotPassword page.
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
                              // Toggle button for switching between login and signup.
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
        ],
      ),
    );
  }
}
