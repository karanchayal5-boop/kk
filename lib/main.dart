import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kk/home/payment_method_page.dart';
import 'package:kk/login/OTP_verification_screen.dart';
import 'package:kk/login/create_password_screen.dart';
import 'package:kk/login/forget_password_screen.dart';
import 'package:kk/login/login_screen.dart';
import 'package:kk/map_screen.dart';
import 'package:kk/login/register_screen.dart';
import 'dart:async';
import 'package:kk/login/screen1.dart';
import 'package:kk/controller/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final AuthController authController = Get.put(AuthController());
  await authController.allUsers();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/screen1', page: () => Screen1()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/otp', page: () => OtpVerificationScreen()),
        GetPage(name: '/createpassword', page: () => CreatePasswordScreen()),
        GetPage(name: '/forget', page: () => ForgotPasswordScreen()),
        GetPage(name: '/map', page: () => MyAppleMap()),
        GetPage(name: '/payment', page: () => PaymentMethodPage()),
         ],
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    if (isLoggedIn) {
      Get.offAllNamed('/map');
    } else {
      Get.offAllNamed('/screen1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo@3x.png',
          width: 300,
        ),
      ),
    );
  }
}
