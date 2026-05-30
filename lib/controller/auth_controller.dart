import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var tempEmail = "".obs;
  RxString tempPhone = "".obs;  

  
Future<bool> linkEmailPassword(String email, String password) async {
  try {
    isLoading.value = true; // loading start

    User? user = FirebaseAuth.instance.currentUser; // current logged-in user (OTP ke baad)

    if (user == null) {
      Get.snackbar("Error", "User not logged in"); // safety check
      return false;
    }

    // email + password ka credential banaya
    AuthCredential credential = EmailAuthProvider.credential(
      email: email, // user ka email
      password: password, // user ka password
    );

    // 🔗 existing user ke sath email+password link kiya
    await user.linkWithCredential(credential);

    // 🔥 Firestore me data save
    await _firestore.collection("users").doc(user.uid).set({
      "phone": tempPhone.value.isEmpty ? tempPhone.value : user.phoneNumber, // phone number save
      "email": email, // email save
      "createdAt": FieldValue.serverTimestamp(), // time save
    }, SetOptions(merge: true));

    Get.snackbar("Success", "Account created successfully"); // success message

    return true;

  } on FirebaseAuthException catch (e) {

    if (e.code == 'email-already-in-use') {
      Get.snackbar("Error", "Email already used");
    } else if (e.code == 'provider-already-linked') {
      Get.snackbar("Error", "Already linked");
    } else {
      Get.snackbar("Error", e.message ?? "Failed");
    }

    return false;

  } finally {
    isLoading.value = false; // loading stop
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

  

  // ================= LOGIN =================
  Future<bool> loginUser(String email, String password) async {
  try {
    isLoading.value = true; // loading start

    await _auth.signInWithEmailAndPassword(
      email: email, // email
      password: password, // password
    );

    Get.snackbar("Success", "Login successful"); // success msg
    return true;

  } on FirebaseAuthException catch (e) {

    if (e.code == 'user-not-found') {
      Get.snackbar("Error", "User not found"); // user exist nahi
    } else if (e.code == 'wrong-password') {
      Get.snackbar("Error", "Wrong password"); // password galat
    } else if (e.code == 'network-request-failed') {
      Get.snackbar("Error", "Internet problem"); // network issue
    } else {
      Get.snackbar("Error", e.message ?? "Login failed"); // other
    }

    return false;

  } finally {
    isLoading.value = false; // loading stop
  }
}

Future<void> sendPasswordResetEmail(String email) async { // function start
  try {
    await _auth.sendPasswordResetEmail(email: email); // firebase ko bolte hai email bhejo

    Get.snackbar(
      "Success",
      "Password reset link sent to your email", // success message
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

  } catch (e) {
    Get.snackbar(
      "Error",
      "Failed to send reset email", // error
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
    print("👋 User logged out");
  }
}