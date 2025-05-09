import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/round_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
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
                decoration: kTextFeildDecoration.copyWith(
                  hintText: 'Enter the E-mail',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  password = value;

                  //Do something with the user input.
                },
                decoration: kTextFeildDecoration.copyWith(
                    hintText: 'Enter the Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(
                colour: Colors.lightBlueAccent,
                text: Text(
                  'Log In',
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final credential = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);

                    if (credential != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    const snackbar = SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(10.0),
                        backgroundColor: Colors.red,
                        content: Text(
                          'Incorrect Email or password',
                          style: TextStyle(color: Colors.white),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
