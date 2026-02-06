import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/auth_controller.dart';
import 'package:kk/login/create_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final AuthController authController = Get.find<AuthController>();
  final List<TextEditingController> otpController =
      List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 230),
                const Text(
                  'Verify your number',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Lorem Ipsum is +91 90231487642 text of the printing.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return _otpBox(
                      first: index == 0,
                      last: index == 3,
                      index: index,
                    );
                  }),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      String enteredOtp = otpController.map((e) => e.text).join();

                      if (enteredOtp.length != 4) {
                        Get.snackbar('Error', 'Please enter the complete OTP.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                        return;
                      }

                      
                        Get.to(() => const CreatePasswordScreen());
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                    ),
                    child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Column(
                    children: [
                      const Text("Didn't receive verification code?", style: TextStyle(color: Colors.black)),
                      TextButton(
                        onPressed: () {
                          
                          Get.snackbar(
                            "OTP Sent",
                            "OTP has been sent to your registered mobile number.",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        child: const Text(
                          'Resend Code.',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _otpBox({required bool first, required bool last, required int index}) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        autofocus: true,
        controller: otpController[index],
        onChanged: (value) {
          if (value.length == 1 && !last) FocusScope.of(context).nextFocus();
          if (value.isEmpty && !first) FocusScope.of(context).previousFocus();
        },
        showCursor: false,
        readOnly: false,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(counterText: "", border: InputBorder.none),
      ),
    );
  }
}
