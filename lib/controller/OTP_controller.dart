import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var verificationId = "".obs;
  var isLoading = false.obs;

  // ================= SEND OTP =================
  Future<void> sendOtp(String phoneNumber) async {
    isLoading.value = true;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Get.snackbar("Success", "Phone number verified successfully.");
      },

      verificationFailed: (FirebaseAuthException e) {
        isLoading.value = false;
        Get.snackbar("OTP Error", e.message ?? "Failed");
      },

      codeSent: (String verId, int? resendToken) {
        verificationId.value = verId;
        isLoading.value = false;
        Get.toNamed('/OtpVerificationScreen');
      },

      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  }

  // ================= VERIFY OTP =================
  Future<bool> verifyOtp(String otp) async {
    try {
      isLoading.value = true;

      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      return true;

    } catch (e) {
      print("otp verification error: $e");
      Get.snackbar("Invalid OTP", e.toString());
      return false;

    } finally {
      isLoading.value = false;
    }
  }
}
