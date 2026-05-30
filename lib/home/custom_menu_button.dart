import 'package:flutter/material.dart';

class CustomMenuButton extends StatelessWidget {
  final VoidCallback onTap;
  const CustomMenuButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: const Icon(Icons.menu),
        ),
      ),
    );
  }
}
