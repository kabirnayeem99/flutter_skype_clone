import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/resources/firebase_method.dart';
import 'package:flutter_skype_clone/resources/firebase_repository.dart';
import 'package:flutter_skype_clone/ui/home_screen.dart';

final FirebaseRepository _firebaseRepository = FirebaseRepository();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loginButton(),
      ),
    );
  }

  Widget loginButton() {
    return RaisedButton(
      child: Text("Log In"),
      onPressed: () {
        performLogin();
      },
    );
  }

  void performLogin() {
    _firebaseRepository.signIn().then((FirebaseUser user) {
      if (user!=null) {
        authenticateUser(user);
      } else {
        print("an error occured");
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    _firebaseRepository.authenticateUser(user).then((isNewUser) {
      if(isNewUser) {
        _firebaseRepository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute (builder: context) {
            return HomeScreen();
          })
        });
      } else {
        
      }
    });
  }
}
