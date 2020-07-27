import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/resources/firebase_repository.dart';
import 'package:flutter_skype_clone/ui/widgets/custom_app_bar.dart';
import 'package:flutter_skype_clone/utils/utilities.dart';

FirebaseRepository _firebaseRepository = FirebaseRepository();

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String currentUserId;
  String initials;

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(text: initials),
      centerTitle: true,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {},),
        IconButton(icon: Icon(Icons.menu), onPressed: () {},),

      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _firebaseRepository.getCurrentUser().then((currentUser) {
      /* get the user id of the signed in user to get the chat lists*/
      setState(() {
        currentUserId = currentUser.uid;
        initials = Utilities.getInitials(currentUser.displayName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: customAppBar(context),
    );
  }
}

// ignore: must_be_immutable
class UserCircle extends StatelessWidget {
  UserCircle({this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      width: 30.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.deepPurple,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 13.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 10.0,
              width: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black38,
                  width: 2.0,
                ),
                color: Colors.greenAccent,
              ),
//              color: Colors.lightGreenAccent,
            ),
          ),
        ],
      ),
    );
  }
}
