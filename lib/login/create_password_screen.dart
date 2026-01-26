import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/auth_controller.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final AuthController authController = Get.find<AuthController>();

  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();

  bool _isObscure1 = true;
  bool _isObscure2 = true;

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
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),

                const Text(
                  'Create password',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 40),

                _buildPasswordField(
                  'Enter password',
                  pass1,
                  _isObscure1,
                  () => setState(() => _isObscure1 = !_isObscure1),
                ),

                const SizedBox(height: 20),

                _buildPasswordField(
                  'Confirm password',
                  pass2,
                  _isObscure2,
                  () => setState(() => _isObscure2 = !_isObscure2),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      String p1 = pass1.text.trim();
                      String p2 = pass2.text.trim();

                      if (p1.isEmpty || p2.isEmpty) {
                        Get.snackbar("Error", "Fill both fields");
                        return;
                      }

                      if (p1.length < 6) {
                        Get.snackbar("Error", "Password must be at least 6 characters");
                        return;
                      }

                      if (p1 != p2) {
                        Get.snackbar("Error", "Passwords do not match");
                        return;
                      }

                      // 🔥 TEMP EMAIL (abhi hardcoded)
                      String email = authController.tempEmail.value;

                      await authController.setCredentials(email, p1);

                      Get.offAllNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    String hint,
    TextEditingController controller,
    bool isObscure,
    VoidCallback toggle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }
}
