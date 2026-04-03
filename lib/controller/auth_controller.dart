import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var tempEmail = "".obs;
  RxString tempPhone = "".obs;  

  
Future<void> createUser({required String password}) async {
  try {
    isLoading.value = true;

    // 🔐 Firebase Auth
    UserCredential userCred = await _auth.createUserWithEmailAndPassword(
      email: tempEmail.value,
      password: password,
    );

    String uid = userCred.user!.uid;

    // 🗄️ Firestore
    await _firestore.collection("users").doc(uid).set({
      "email": tempEmail.value,
      "createdAt": FieldValue.serverTimestamp(),
    });

    print("✅ User registered & saved in Firestore");
  } catch (e) {
    print("❌ Create user error: $e");
  } finally {
    isLoading.value = false;
  }
}

Future<Map<String, dynamic>?> getUserProfile() async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  DocumentSnapshot doc =
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

  return doc.data() as Map<String, dynamic>;
}

  // ================= SIGNUP =================
  Future<bool> registerUser(
    String name,
    String email,
    String password,
  ) async {
    try {
      isLoading.value = true;

      // 🔐 Firebase Auth
      UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCred.user!.uid;

      // 🗄️ Firestore
      await _firestore.collection("users").doc(uid).set({
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("✅ User registered & saved in Firestore");
      return true;
    } catch (e) {
      print("❌ Register error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOGIN =================
  Future<bool> loginUser(String email, String password) async {
    try {
      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("✅ Login success");
      return true;
    } catch (e) {
      print("❌ Login error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
    print("👋 User logged out");
  }
}