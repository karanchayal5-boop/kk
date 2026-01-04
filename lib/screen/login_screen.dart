import 'package:flutter/material.dart';

// 1. StatefulWidget banayein taaki error state change ho sake
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 2. Variable jo track karega ki error dikhana hai ya nahi
  bool isPasswordWrong = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/login.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 230),
                const Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // 3. ERROR MESSAGE LOGIC
                if (isPasswordWrong)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        const Text(
                          "Incorrect Password. ",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Password reset logic
                          },
                          child: const Text(
                            "Reset your password.",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                _buildTextField('Email address'),
                const SizedBox(height: 15),
                _buildTextField('Password'),
                const SizedBox(height: 30),

                // 4. LOGIN BUTTON CLICK LOGIC
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Testing ke liye: Button dabate hi error dikhega
                      setState(() {
                        isPasswordWrong = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Baaki ka code (Create account aur Terms) same rahega...
                Center(
                  child: Column(
                    children: [
                      const Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Create new account.',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text("By logging in you are agree to Terms & conditions", 
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Container(
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
        onChanged: (value) {
          // Jab user type karna shuru kare, error hata dein
          if (isPasswordWrong) {
            setState(() {
              isPasswordWrong = false;
            });
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}