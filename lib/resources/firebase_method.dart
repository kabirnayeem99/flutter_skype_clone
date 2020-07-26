import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_repository.dart';

class FirebaseRepository {
  final _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore _firestore = Firestore.instance;

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
    FirebaseUser user = (await _auth.signInWithCredential(credential))
        as FirebaseUser; // to sign in the user
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    /*
    It will check if the user is already signed in with his account
    by matching his email with the documents. and if he is not signed in
    his documents would be empty and he needs to authenticate, otherwise
    he will be directly signed in.
     */
    QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }
}
