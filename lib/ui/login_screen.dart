import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/resources/firebase_method.dart';
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
      if (user != null) {
        authenticateUser(user);
      } else {
        print("an error occured");
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    /* This function will check if this user is authenticated by chekcing if he
    is a new user. If he is a new user, the function to sign up him will be
    called, or he will directly redirect to HomeScree.*/

    _firebaseRepository.authenticateUser(user).then(
      (isNewUser) {
        if (isNewUser) {
          _firebaseRepository.addDataToDb(user).then(
            (value) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          );
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        }
      },
    );
  }
}
