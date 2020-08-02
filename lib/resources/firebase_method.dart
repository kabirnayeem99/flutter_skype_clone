import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_skype_clone/constants/strings.dart';
import 'package:flutter_skype_clone/models/message.dart';
import 'package:flutter_skype_clone/provider/image_upload_provider.dart';
import 'package:flutter_skype_clone/utils/utilities.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_skype_clone/models/user.dart';

class FirebaseMethod {
  final _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore _firestore = Firestore.instance;
  User user = User();
  Utils utilities = Utils();
  StorageReference _storageReference;

  Future<FirebaseUser> getCurrentUser() async {
    /*
    a function that for the sake of sign in will check the current user
     */
    FirebaseUser currentUser =
        await _auth.currentUser(); // getting the current user
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    /*
    will sign in using the google authentication
     */
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    // retrieve google sign in authentication for the user
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _signInAuthentication.idToken,
      accessToken: _signInAuthentication.accessToken,
    );
    AuthResult result =
        await _auth.signInWithCredential(credential); // to sign in the user
    return result.user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    /*
    It will check if the user is already signed in with his account
    by matching his email with the documents. and if he is not signed in
    his documents would be empty and he needs to authenticate, otherwise
    he will be directly signed in.
     */
    QuerySnapshot result = await _firestore
        .collection(sUserCollection)
        .where(sEmailField, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    /* This will access the gmail account of the user and will the collect the 
    data and will write it to a map and the map will be saved to the unique
    uid(documents) of the user while isolated. */
    user = User(
      uid: currentUser.uid,
      name: currentUser.displayName,
      username: Utils.getUsername(
        currentUser.email,
      ),
      email: currentUser.email,
      profilePhoto: currentUser.photoUrl,
    ); // making user model by
    _firestore
        .collection(sUserCollection)
        .document(currentUser.uid)
        .setData(user.toMap(user)); // writing data to the database
  }

  Future<void> addMessageToDb(
      Message message, User sender, User reciever) async {
    var map = message.toMap();
    await _firestore
        .collection(sMessagesCollection)
        .document(message.senderId)
        .collection(message.recieverId)
        .add(map);

    return _firestore
        .collection(sMessagesCollection)
        .document(message.recieverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<void> signOut() async {
    _googleSignIn.disconnect(); //disconnect their Google account from this app
    print("disconnecting from google");
    _googleSignIn.signOut(); // code clears which account is connected here
    print("SIgning out");
    _auth.signOut(); // signout from FirebaseAuth as well
  }

  Future<List<User>> fethUserList(FirebaseUser currentUser) async {
    /*
    This method will create a user list from the document snapshot. But before
    doing so, it will check so that the current user is not included by
    excluding his documentId.
     */
    List<User> userList = [];
    QuerySnapshot querySnapshot =
        await _firestore.collection(sUserCollection).getDocuments();

    for (DocumentSnapshot eachSnapshot in querySnapshot.documents) {
      if (eachSnapshot.documentID != currentUser.uid) {
        // retrieve the user model and embed it into a map.
        userList.add(User.fromMap(eachSnapshot.data));
      }
    }

    return userList;
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<DocumentReference> setImageMessage(
    String url,
    String recieverId,
    String senderId,
  ) async {
    Message _message;
    _message = Message.imageMessage(
      message: "IMAGE",
      recieverId: recieverId,
      senderId: senderId,
      photoUrl: url,
      timeStamp: Timestamp.now(),
      type: "image",
    );

    var _map = _message.toImageMap();
    await _firestore
        .collection(sMessagesCollection)
        .document(_message.senderId)
        .collection(_message.recieverId)
        .add(_map);

    return _firestore
        .collection(sMessagesCollection)
        .document(_message.recieverId)
        .collection(_message.senderId)
        .add(_map);
  }

  void uploadImage(
    File image,
    String recieverId,
    String senderId,
    ImageUploadProvider imageUploadProvider,
  ) async {
    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    setImageMessage(
      url,
      recieverId,
      senderId,
    );
  }
}
