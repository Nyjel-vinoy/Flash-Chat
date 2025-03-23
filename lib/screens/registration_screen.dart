import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/round_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String Password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration:
                    kTextFeildDecoration.copyWith(hintText: 'Enter the E-mail'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  Password = value;
                },
                decoration: kTextFeildDecoration.copyWith(
                    hintText: 'Enter the Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(
                colour: Colors.blueAccent,
                text: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final credential =
                        await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: Password,
                    );
                    if (credential != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } on FirebaseAuthException catch (e) {
                    print(e.code);
                    if (e.code == 'email-already-in-use') {
                      setState(() {
                        showSpinner = false;
                      });
                      final snackbar =
                          SnackBar(content: Text('The user already exist'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } else if (e.code == 'weak-password') {
                      setState(() {
                        showSpinner = false;
                      });
                      const snackbar = SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(10.0),
                          backgroundColor: Colors.red,
                          content: Text(
                            'Weak password',
                            style: TextStyle(color: Colors.white),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } else {
                      setState(() {
                        showSpinner = false;
                      });
                      const snackbar = SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(10.0),
                          backgroundColor: Colors.red,
                          content: Text(
                            'Check password again',
                            style: TextStyle(color: Colors.white),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
