import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_method.dart';

class FirebaseRepository {
  FirebaseMethod _firebaseMethod = FirebaseMethod();
  Future<FirebaseUser> getCurrentUser() => _firebaseMethod.getCurrentUser();
  Future<FirebaseUser> signIn() => _firebaseMethod.signIn();
  Future<bool> authenticateUser(user) => _firebaseMethod.authenticateUser(user);
  Future<void> addDataToDb(user) => _firebaseMethod.addDataToDb(user);
  Future<void> signOut() => _firebaseMethod.signOut();
}
