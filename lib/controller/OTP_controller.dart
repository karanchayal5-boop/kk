import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var verificationId = "".obs;
  var isLoading = false.obs;

  // ================= SEND OTP =================
  Future<void> sendOtp(String phone) async {
    isLoading.value = true;

    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        Get.offAllNamed('/map');
      },

      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("Error", e.message ?? "OTP Failed");
        isLoading.value = false;
      },

      codeSent: (String verId, int? resendToken) {
        verificationId.value = verId;
        isLoading.value = false;
        Get.toNamed('/otp');
      },

      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  }

  // ================= VERIFY OTP =================
  Future<void> verifyOtp(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await auth.signInWithCredential(credential);
      Get.offAllNamed('/createpassword');

    } catch (e) {
      Get.snackbar("Error", "Invalid OTP");
    }
  }
}
