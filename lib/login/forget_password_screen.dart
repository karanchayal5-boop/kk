import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/login.png',
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
      
            Positioned(
              top: 60,
              left: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 200),
      
                  const Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
      
                  const Text(
                    'Please enter your registered email address and you’ll receive an OTP to reset your password.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
      
                  const SizedBox(height: 50),
      
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email address',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 40),
      
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () async {
                                String email = _emailController.text.trim();
      
                                if (!GetUtils.isEmail(email)) {
                                  Get.snackbar(
                                    "Invalid Email",
                                    "Please enter valid email",
                                  );
                                  return;
                                }
      
                                await authController.sendPasswordResetEmail(
                                  email,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: authController.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
