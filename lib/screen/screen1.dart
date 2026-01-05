import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
 
  bool _isMoved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
         
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/image.png',
                    height: MediaQuery.of(context).size.width * 1.37,
                    fit: BoxFit.contain,
                  ),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  left: _isMoved ? -400 : 50, 
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/couple@3x.png',
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  right: _isMoved ? -180 : -700, 
                  bottom: 120, 
                  child: Image.asset(
                    'assets/images/car.png', 
                    width: 480,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  Text(
                    _isMoved 
                      ? 'We provide all kinds of taxi\ncab services.' 
                      : 'Are you planning to visit\nfazilka,Abohar.',
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _isMoved
                      ? 'like Airport Transfer, Platinum Service, Business Travel, Silver Taxi Service, and so on.'
                      : 'We guarantee for Death, reliable, professional, affordable experience inside of our top-notch vehicles.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const Spacer(),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildIndicator(!_isMoved),
                          const SizedBox(width: 5),
                          _buildIndicator(_isMoved),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!_isMoved) {
                              _isMoved = true; 
                            } else {
                              print("Na");
                              Get.offNamed('/login'); 
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 25 : 15,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}