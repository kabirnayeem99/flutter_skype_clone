import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_skype_clone/models/message.dart';
import 'package:flutter_skype_clone/models/user.dart';
import 'package:flutter_skype_clone/provider/image_upload_provider.dart';
import 'package:flutter_skype_clone/resources/firebase_method.dart';

class FirebaseRepository {
  FirebaseMethod _firebaseMethod = FirebaseMethod();
  Future<FirebaseUser> getCurrentUser() => _firebaseMethod.getCurrentUser();
  Future<FirebaseUser> signIn() => _firebaseMethod.signIn();
  Future<bool> authenticateUser(user) => _firebaseMethod.authenticateUser(user);
  Future<void> addDataToDb(user) => _firebaseMethod.addDataToDb(user);
  Future<void> signOut() => _firebaseMethod.signOut();
  Future<List<User>> fethUserList(FirebaseUser currentUser) =>
      _firebaseMethod.fethUserList(currentUser);
  Future<void> addMessageToDb(Message message, User sender, User reciever) =>
      _firebaseMethod.addMessageToDb(message, sender, reciever);
  void uploadImage({
    @required File image,
    @required String recieverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,

  }) =>
      _firebaseMethod.uploadImage(
        image,
        recieverId,
        senderId,
        imageUploadProvider,
      );
}
