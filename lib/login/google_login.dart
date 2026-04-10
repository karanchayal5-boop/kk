import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // user Google account choose karega

    if (googleUser == null) {
      print("❌ User cancelled login");
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // tokens mil gaye

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    // Firebase login

    print("✅ Login Success: ${userCredential.user?.email}");

  } catch (e) {
    print("🔥 Google Login Error: $e");
  }
}