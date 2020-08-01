import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_skype_clone/enum/view_stat.dart';
import 'package:flutter_skype_clone/models/message.dart';
import 'package:flutter_skype_clone/models/user.dart';
import 'package:flutter_skype_clone/provider/image_upload_provider.dart';
import 'package:flutter_skype_clone/resources/firebase_repository.dart';
import 'package:flutter_skype_clone/ui/widgets/custom_app_bar.dart';
import 'package:flutter_skype_clone/ui/widgets/custom_tile.dart';
import 'package:flutter_skype_clone/utils/universal_var.dart';
import 'package:flutter_skype_clone/constants/strings.dart';
import 'package:flutter_skype_clone/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.reciever}); // get the id from the search

  final User reciever;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageEditingController = TextEditingController();
  bool isWriting = false;
  bool showEmojiPicker = false;
  User sender;
  String _currentUserId;
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  ScrollController _listScroolController = ScrollController();
  FocusNode messageFocusNode = FocusNode();
  ImageUploadProvider _imageUploadProvider;

  @override
  void initState() {
    super.initState();
    _firebaseRepository.getCurrentUser().then((user) {
      /*
      will get the current user and using the user model
      it will create a user object named sender, which will be assigned the user
      id of current user.
       */
      _currentUserId = user.uid; // getting the user id of current user

      setState(() {
        sender = User(
          // creating a user model named sender based on current user
          uid: _currentUserId,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          RaisedButton(
            color: Colors.deepPurpleAccent,
            child: Text("Change View State"),
            onPressed: () {
              print("Button Pressed");
              _imageUploadProvider.getViewState == ViewState.LOADING
                  ? _imageUploadProvider.setToIdle()
                  : _imageUploadProvider.setToLoading();
              print(_imageUploadProvider.getViewState);
            },
          ),
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? CircularProgressIndicator()
              : Container(),
          chatControlls(),
          showEmojiPicker
              ? Container(
                  child: emojiContainer(),
                )
              : Container(),
        ],
      ),
    );
  }

  showKeyboard() => messageFocusNode.requestFocus();
  hideKeyboard() => messageFocusNode.unfocus();
  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  Widget emojiContainer() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: EmojiPicker(
          buttonMode: ButtonMode.MATERIAL,
          rows: 3,
          columns: 6,
          bgColor: UniversalVariables.blackColor,
          indicatorColor: Colors.deepPurpleAccent,
          recommendKeywords: ["love", "face", "happy"],
          numRecommended: 20,
          onEmojiSelected: (emoji, category) {
            setState(() {
              isWriting = true;
            });
            messageEditingController.text =
                messageEditingController.text + emoji.emoji;
          },
        ),
      ),
    );
  }

  sendMessage() {
    var text = messageEditingController.text; // to get the recent text

    Message _message = Message(
      recieverId: widget.reciever.uid,
      senderId: sender.uid,
      message: text,
      type: sTextType,
      timeStamp: Timestamp.now(),
    );

    setState(() {
      // after hitting the send button the send button should disappear
      isWriting = false;
    });

    messageEditingController.text = ""; // clears the text box

    _firebaseRepository.addMessageToDb(_message, sender, widget.reciever);
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(sMessagesCollection)
          .document(_currentUserId)
          .collection(widget.reciever.uid)
          .orderBy(sTimeStampOrder, descending: true)
          .snapshots(), // getting the snapshot of the data in real time
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          _listScroolController.animateTo(
            _listScroolController.position.minScrollExtent,
            duration: Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        });

        return ListView.builder(
          padding: EdgeInsets.all(10.0),
          reverse: true,
          controller: _listScroolController,
          itemBuilder: (context, index) {
            // check every message by index and give it to chatmessageitem
            // to build a bubble
            return chatMessageItem(snapshot.data.documents[index]);
          },
          itemCount: snapshot.data.documents.length,
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.bottomRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayOut(_message)
            : recieverLayOut(_message),
      ),
    );
  }

  getMessage(Message message) {
    return Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }

  Widget senderLayOut(Message message) {
    Radius messageRadius = Radius.circular(20.0);

    return Container(
      margin: EdgeInsets.only(top: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .65,
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
        child: getMessage(message),
      ),
    );
  }

  Widget recieverLayOut(Message message) {
    Radius messageRadius = Radius.circular(20.0);

    return Container(
      margin: EdgeInsets.only(top: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
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
        child: getMessage(message),
      ),
    );
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
            child: Stack(
              children: <Widget>[
                TextField(
                  onTap: () => hideEmojiContainer(),
                  focusNode: messageFocusNode,
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
                  ),
                  onChanged: (value) {
                    (value.length > 0 && value.trim() != "")
                        ? setWriting(true)
                        : setWriting(false);
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      if (!showEmojiPicker) {
                        hideKeyboard();
                        showEmojiContainer();
                      } else {
                        showKeyboard();
                        hideEmojiContainer();
                      }
                    },
                    icon: Icon(
                      Icons.insert_emoticon,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child:
                      GestureDetector(onTap: () => {}, child: Icon(Icons.mic)),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(
                    source: ImageSource.camera,
                  ),
                  child: Icon(Icons.camera_alt),
                ),
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
                      onPressed: () {
                        sendMessage();
                      },
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  pickImage({@required ImageSource source}) async {
    print("camera button pressed");
    File selectedImage = await Utils.pickImage(source: source);
    _firebaseRepository.uploadImage(
      image: selectedImage,
      recieverId: widget.reciever.uid,
      senderId: _currentUserId,
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
