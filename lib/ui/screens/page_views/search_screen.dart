import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/models/user.dart';
import 'package:flutter_skype_clone/resources/firebase_repository.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  List<User> userList;
  String query;
  TextEditingController searchEditingController = TextEditingController();

  searchAppBar(BuildContext context) {
    return GradientAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: 05.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
          ),
          child: TextField(
            controller: searchEditingController,
            autocorrect: true,
            cursorColor: Colors.black38,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30.0,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search",
              suffixIcon: IconButton(
                // there will a icon, clicking which will clear the textfield
                icon: Icon(Icons.clear),
                onPressed: () => searchEditingController.clear(),
              ),
            ),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _firebaseRepository.getCurrentUser().then((FirebaseUser user) {
      // getting the existing user for its uid
      _firebaseRepository.fethUserList(user).then((List<User> list) {
        // using the uid I'm excluding him from the search list
        // assigning the found list to the  userList.
        userList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchAppBar(context),
      backgroundColor: Colors.black38,
    );
  }
}
