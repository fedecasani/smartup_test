import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartup_test/global/toast.dart';

class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The account already exists for that email.');
      } else {
        showToast(message: 'Some error occurred: ${e.code}');
      }
    } catch (e) {
      showToast(message: 'An unexpected error occurred: $e');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'Some error occurred: ${e.code}');
      }
    } catch (e) {
      showToast(message: 'An unexpected error occurred: $e');
    }
    return null;
  }
}