import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skype_clone/models/user.dart';
import 'package:flutter_skype_clone/ui/widgets/custom_app_bar.dart';
import 'package:flutter_skype_clone/ui/widgets/custom_tile.dart';
import 'package:flutter_skype_clone/utils/universal_var.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.reciever});

  final User reciever;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageEditingController = TextEditingController();
  bool isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControlls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: 18,
      itemBuilder: (context, index) {
        return chatMessageItem();
      },
    );
  }

  Widget chatMessageItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Container(
        child: recieverLayOut(),
      ),
    );
  }

  Widget senderLayOut() {
    Radius messageRadius = Radius.circular(20.0);

    return Container(
      width: 60,
      margin: EdgeInsets.only(top: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .5,
      ),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "Who are you?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget recieverLayOut() {
    Radius messageRadius = Radius.circular(20.0);

    return Container(
        margin: EdgeInsets.only(top: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
          minWidth: MediaQuery.of(context).size.width * 0.10,
        ),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          ),
        ),
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Hi?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            )));
  }

  Widget chatControlls() {
    setWriting(value) {
      setState(() {
        isWriting = value;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
        context: context,
        elevation: 5.0,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.arrow_downward),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content & Tools",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ModalTile(
                      title: "Media",
                      subtitle: "Share your media.",
                      icon: Icons.photo,
                    ),
                    ModalTile(
                      title: "File",
                      subtitle: "Share your File.",
                      icon: Icons.attach_file,
                    ),
                    ModalTile(
                      title: "Contact",
                      subtitle: "Share your contact.",
                      icon: Icons.perm_contact_calendar,
                    ),
                    ModalTile(
                      title: "Location",
                      subtitle: "Share your location.",
                      icon: Icons.my_location,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: TextField(
              controller: messageEditingController,
              cursorColor: Colors.deepPurple,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Enter your message.",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5.0,
                ),
                filled: true,
                fillColor: Color(0xff222222),
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey,
                  ),
                ),
              ),
              onChanged: (value) {
                (value.length > 0 && value.trim() != "")
                    ? setWriting(true)
                    : setWriting(false);
              },
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.photo_camera),
                ),
          isWriting ? Container() : Icon(Icons.mic),
          isWriting
              ? Container(
//                  height: 30.0,
//                  width: 30.0,
                  margin: EdgeInsets.only(left: 10.0),

                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 20.0,
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      title: Text(widget.reciever.name),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.call),
          onPressed: () {},
        ),
      ],
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    Key key,
    this.title,
    this.subtitle,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: CustomTile(
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(
            right: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: UniversalVariables.blackColor,
          ),
          padding: EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
