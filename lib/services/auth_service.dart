import 'package:firebase_auth/firebase_auth.dart';
import '../constants/constants.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = firestore;

  static Future<bool> signUp(String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? signedInUser = authResult.user;

      if (signedInUser != null) {
        _firestore.collection('users').doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          'profilepicture':
              'https://firebasestorage.googleapis.com/v0/b/myfirebase-db-75c27.appspot.com/o/default_photos%2Fprofile_photo.png?alt=media&token=b370d33b-a581-48f2-8a4e-dcd8ae6f96fb&_gl=1*jlrzut*_ga*MTk3Mzk1MjgyLjE2OTY5NDgwMTQ.*_ga_CW55HF8NVT*MTY5NzI3MDQwMi41LjEuMTY5NzI3MjExMS40OS4wLjA.',
          'coverimage':
              'https://firebasestorage.googleapis.com/v0/b/myfirebase-db-75c27.appspot.com/o/default_photos%2Fcover_photo_user.jpg?alt=media&token=517ba625-edf4-4821-8cdc-6c43c678f5ed&_gl=1*1d3klyt*_ga*MTk3Mzk1MjgyLjE2OTY5NDgwMTQ.*_ga_CW55HF8NVT*MTY5NzI3MDQwMi41LjEuMTY5NzI3MjQ5MC40OC4wLjA.',
          'bio': 'Hey there! I am using ConnectZ'
        });

        followingRef
            .doc(signedInUser.uid)
            .collection('following')
            .doc(signedInUser.uid)
            .set({});

        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
