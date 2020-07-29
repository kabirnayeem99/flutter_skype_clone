import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/resources/firebase_method.dart';
import 'file:///D:/Projects/flutter_skype_clone/lib/ui/screens/home_screen.dart';
import 'file:///D:/Projects/flutter_skype_clone/lib/ui/screens/login_screen.dart';
import 'package:flutter_skype_clone/ui/screens/page_views/search_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FirebaseMethod _firebaseRepository = FirebaseMethod();
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      title: "FluSkipe",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/search_screen": (context) => SearchScreen(),
      },
      home: FutureBuilder(
        future: _firebaseRepository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
