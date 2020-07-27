import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/resources/firebase_method.dart';
import 'package:flutter_skype_clone/resources/firebase_repository.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: RaisedButton(
          child: Text(
            "Sign Out",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Colors.purple,
          onPressed: () {
            final _firebaserepository = FirebaseRepository();
             _firebaserepository.signOut().then(
              (value) {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
