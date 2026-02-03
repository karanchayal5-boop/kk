import 'dart:math';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kk/map_screen.dart';
import 'package:kk/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // ================= DIO SETUP =================
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://69805b5a6570ee87d50ee3f1.mockapi.io",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  // ================= OBSERVABLES =================
  var allUsers = <UserModel>[].obs;
  var generatedOtp = "".obs;

  var savedEmail = "".obs;
  var savedPassword = "".obs;
  var tempEmail = "".obs;
  var tempName = "".obs;

  // ================= SAVE LOGIN SESSION =================
  Future<void> saveLoginSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("currentUser", email);

    print("👍 Login session saved for: $email");
  }

  // ================= SIGNUP (POST) =================
  Future<bool> registerUser(
    String name,
    String email, 
    String password,
    ) async {
    try {
      final response = await dio.post(
        "/users",
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );

      print("😁 User Registered: ${response.data}");
      return true;
    } catch (e) {
      print("😭 Register Error: $e");
      return false;
    }
  }

  // ================= FETCH USERS (GET) =================
  Future<void> fetchUsers() async {
    try {
      final response = await dio.get("/users");

      List<UserModel> users = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();

      allUsers.value = users;

      print("👍 Users fetched: ${users.length}");
    } catch (e) {
      print("😩 Fetch Error: $e");
    }
  }

  // ================= LOGIN (GET + CHECK) =================
  Future<bool> loginUser(String email, String password) async {
    try {
      final response = await dio.get("/users");

      List<UserModel> users = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();

      bool success =
          users.any((u) => u.email == email && u.password == password);

      if (success) {
        await saveLoginSession(email);
        print("👍 Login success");
      } else {
        print("😔 Invalid credentials");
      }

      return success;
    } catch (e) {
      print("😩 Login Error: $e");
      return false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLoggedIn");
    await prefs.remove("currentUser");

    Get.offAll(() => MyAppleMap());
  }

  // ================= OTP SYSTEM =================
  void sendOtp() {
    int otp = 1000 + Random().nextInt(9000);
    generatedOtp.value = otp.toString();
    print("📩 OTP is: ${generatedOtp.value}");
  }

  bool verifyOtp(String inputOtp) {
    return inputOtp == generatedOtp.value;
  }
}
