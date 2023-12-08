import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset password',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Mont',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 106, 187, 241),
          ),
        ),
      ),
      key: _scaffoldKey,
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              withEmail(),
            ],
          );
        },
      ),
    );
  }

  Widget withEmail() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Enter your email and press continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 106, 187, 241),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 106, 187, 241)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: SizedBox(
                  // Added container to wrap the FlatButton
                  width: double.infinity, // Make the button take the full width
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _auth.sendPasswordResetEmail(
                            email: _emailController.text);
                        await showAlertDialog(context);
                        Navigator.of(context).pop();
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Mont',
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 106, 187, 241),
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

  showAlertDialog(BuildContext context) async {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Password reset link sent"),
      content: const Text(
          "Please follow the instructions in the email to reset your password."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
