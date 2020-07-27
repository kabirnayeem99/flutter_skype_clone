import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'file:///D:/Projects/flutter_skype_clone/lib/utils/utilities.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_skype_clone/models/user.dart';

class FirebaseMethod {
  final _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore _firestore = Firestore.instance;
  User user = User();
  Utilities utilities = Utilities();

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
    AuthResult result = await _auth.signInWithCredential(credential); // to sign in the user
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
        .collection("users")
        .where("email", isEqualTo: user.email)
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
      username: Utilities.getUsername(
        currentUser.uid,
        currentUser.email,
      ),
      email: currentUser.email,
      profilePhoto: currentUser.photoUrl,
    ); // making user model by 
    _firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user)); // writing data to the database
  }

  Future<void> signOut() async {
    _googleSignIn.disconnect(); //disconnect their Google account from this app
    print("disconnecting from google");
    _googleSignIn.signOut(); // code clears which account is connected here
    print("SIgning out");
    _auth.signOut(); // signout from FirebaseAuth as well
  }
}
