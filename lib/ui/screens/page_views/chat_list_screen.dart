import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/resources/firebase_repository.dart';
import 'package:flutter_skype_clone/ui/widgets/custom_app_bar.dart';
import 'package:flutter_skype_clone/ui/widgets/custom_tile.dart';
import 'package:flutter_skype_clone/utils/universal_var.dart';
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
          size: 20.0,
        ),
        onPressed: () {},
      ),
      title: UserCircle(text: initials),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          iconSize: 20.0,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          iconSize: 20.0,
          onPressed: () {},
        ),
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
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(currentUserId: currentUserId),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final currentUserId;
  ChatListContainer({this.currentUserId});
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return CustomTile(
          mini: false,
          onTap: () {},
          leading: Container(
            constraints: BoxConstraints(
              maxHeight: 40.0,
              maxWidth: 40.0,
            ),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 20.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                      "https://www.accenture.com/t20180507T105237Z__w__/us-en/_acnmedia/Accenture/Conversion-Assets/DotCom/Images/Global-3/23/Accenture-World-Network.pngla=en"),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightGreenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            "Nadan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Hi, how are you?",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    ));
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

                color: Colors.lightGreenAccent,
              ),
//              color: Colors.lightGreenAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Icon(
        Icons.chat_bubble,
        color: Colors.white,
        size: 20.0,
      ),
      padding: EdgeInsets.all(5.0),
    );
  }
}