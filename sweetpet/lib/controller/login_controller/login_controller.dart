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

final _firebase = FirebaseAuth.instance;

class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

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

    if (!isValid || (!_isLogin && _selectedImage == null)) {
      return;
    }

    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        if (_isEmailAndPassword) {
          final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword,
          );
          globalUid = userCredentials.user!.uid;
        } else {
          await _sendEmailLink();
        }
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

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

      Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
    } finally {
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
          url: "your_deep_link_url",
          handleCodeInApp: true,
          iOSBundleId: "your_ios_bundle_id",
          androidPackageName: "your_android_package_name",
          androidInstallApp: true,
          androidMinimumVersion: "12",
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
                                  !value.contains('@')) {
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
                              if (value == null || value.trim().length < 6) {
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
                          if (!_isAuthenticating && _isEmailAndPassword)
                            Container(
                              width: double
                                  .infinity, // Set the width to match the parent
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(200, 248, 255, 1),
                                  elevation: 0, // Remove button shadow
                                ),
                                child: Text(
                                  _isLogin ? 'Log In With Password' : 'Sign Up',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Mont',
                                    fontWeight: FontWeight.w900,
                                    color: Color.fromARGB(255, 106, 187, 241),
                                  ),
                                ),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEmailAndPassword = !_isEmailAndPassword;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(200, 248, 255, 1),
                              elevation: 0, // Remove button shadow
                            ),
                            child: Container(
                              width: double.infinity, // Set a fixed width
                              alignment: Alignment
                                  .center, // Center the text horizontally
                              child: Text(
                                _isEmailAndPassword && !_isLogin
                                    ? 'Switch to Email Link Login'
                                    : 'Switch to Password Login',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromARGB(255, 106, 187, 241),
                                ),
                              ),
                            ),
                          ),
                          if (!_isAuthenticating && !_isEmailAndPassword)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(200, 248, 255, 1),
                                elevation: 0, // Remove button shadow
                              ),
                              child: Text(
                                _isLogin ? 'Log In With Email' : 'Sign Up',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromARGB(255, 106, 187, 241),
                                ),
                              ),
                            ),
                          Container(
                            width: double
                                .infinity, // Set the width to match the parent
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 106, 187, 241),
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
                                    side: const BorderSide(color: Colors.grey),
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
                                    color: Color.fromARGB(255, 106, 187, 241),
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
    );
  }
}
