import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationServices {
  // Singleton instance of the class
  static AuthenticationServices? instance = AuthenticationServices._();
  AuthenticationServices._();

  factory AuthenticationServices.getInstance() {
    instance ??= AuthenticationServices._();
    return instance!;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // Logout the current user
  Future<bool> logout() async {
    final user = currentUser;
    if (user == null) return false;

    // Sign out from Firebase
    await _firebaseAuth.signOut();
    // Sign out from Google Sign In
    final googleAccount = await _googleSignIn.signOut();
    if (googleAccount == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

      if (googleAccount == null) return null;
      // Get the authentication details from the signed-in Google account
      final GoogleSignInAuthentication googleAuthentication =
          await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      );

      // Sign in to Firebase with the Google credentials
      await _firebaseAuth.signInWithCredential(credential);

      final user = currentUser;
      return user;
    } catch (e) {
      return null;
    }
  }

  User? get currentUser {
    final User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
}
