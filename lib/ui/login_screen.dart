import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/resources/firebase_method.dart';
import 'package:flutter_skype_clone/ui/home_screen.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseMethod _firebaseRepository = FirebaseMethod();
  bool isLogInPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: loginButton(),
          ),
          isLogInPressed
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
      backgroundColor: Colors.black38,
    );
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white60,
      highlightColor: Colors.black38,
      child: FlatButton(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "LogIn",
          style: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.1,
            wordSpacing: .01,
            fontSize: 30.0,
          ),
        ),
        onPressed: () {
          performLogin();
        },
      ),
    );
  }

  void performLogin() {
    setState(() {
      // the loading screen shows up
      isLogInPressed = true;
    });
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
        setState(() {
          // as authinticated loading screen turns off
          isLogInPressed = false;
        });

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
