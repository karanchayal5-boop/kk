import 'dart:math';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var generatedOtp = "".obs;

  var savedEmail = "".obs;
  var savedPassword = "".obs;

  var tempEmail = "".obs;

  get auth => null;

  // ================= SAVE EMAIL + PASSWORD =================
  Future<void> setCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);

    savedEmail.value = email;
    savedPassword.value = password;

    print(" Saved Email: ${savedEmail.value}");
    print(" Saved Password: ${savedPassword.value}");
  }

  // ================= LOAD FROM STORAGE =================
  Future<void> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    savedEmail.value = prefs.getString('user_email') ?? "";
    savedPassword.value = prefs.getString('user_password') ?? "";

    print(" Loaded Email: ${savedEmail.value}");
    print(" Loaded Password: ${savedPassword.value}");
  }

  // ================= LOGIN CHECK =================
  bool login(String email, String password) {
    print(" Entered: $email / $password");
    print(" Saved: ${savedEmail.value} / ${savedPassword.value}");

    return email == savedEmail.value && password == savedPassword.value;
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_password');

    savedEmail.value = "";
    savedPassword.value = "";

    print(" User logged out, credentials cleared.");
  }

  // ================= OTP =================
  void sendOtp() {
    int otp = 1000 + Random().nextInt(9000); // 4 digit
    generatedOtp.value = otp.toString();
    print(" Karan your OTP IS: ${generatedOtp.value}");
  }

  bool verifyOtp(String inputOtp) {
    return inputOtp == generatedOtp.value;
  }

  void saveUserData(String text, String mobileNumber) {}
}
