import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kk/controller/otp_controller.dart';
import 'package:kk/controller/auth_controller.dart';
import 'package:kk/firebase_options.dart';
import 'package:kk/home/payment_method_page.dart';
import 'package:kk/login/OTP_verification_screen.dart';
import 'package:kk/login/create_password_screen.dart';
import 'package:kk/login/forget_password_screen.dart';
import 'package:kk/login/login_screen.dart';
import 'package:kk/map_screen.dart';
import 'package:kk/login/register_screen.dart';
import 'dart:async';
import 'package:kk/login/screen1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("background message: ${message.messageId}");
    
  }
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
    await requestNotificationPermission();
    await FirebaseMessaging.instance.requestPermission();
    await getToken();
    setupForegroundListener();
    await setupNotification();
   
   
    Get.put(OtpController());
    Get.put(AuthController(), permanent: true);


  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
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



Future<void> requestNotificationPermission() async {
  await Permission.notification.request();
}

Future<void> setupNotification() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print("User granted permission: ${settings.authorizationStatus}");
}

Future<void> getToken() async {
  await Future.delayed( const Duration(seconds: 2));
  String? token = await FirebaseMessaging.instance.getAPNSToken();
  print("APNS Token: $token");
}

void setupForegroundListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("title: ${message.notification?.title}");
    print("body: ${message.notification?.body}");

    Get.snackbar(
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
    );
  });
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
  await Future.delayed(const Duration(seconds: 3));

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // already logged in
    Get.offAllNamed('/map');
  } else {
    // not logged in
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
