import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  bool _isMoved = false;
  
  Null get offsetAnimation => null;

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
                    height: MediaQuery.of(context).size.width * 1.36,
                    fit: BoxFit.contain,
                  ),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  right: _isMoved ? 400 : 130,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/couple@3x.png',
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  right: _isMoved ? -160 : -700,
                  bottom: 110,
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

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      
                      final isInAnimation = child.key == ValueKey<bool>(_isMoved);
                      
                      return SlideTransition(
                        position: Tween<Offset>(
                          
                          begin: isInAnimation ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Text(
                    _isMoved
                        ? 'We provide all kinds of taxi cab services.'
                        : 'Are you planning to visit\nfazilka,Abohar.',
                    key: ValueKey<bool>(_isMoved ),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 1),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      
                      final isInAnimation = child.key == ValueKey<bool>(_isMoved);
                      
                      return SlideTransition(
                        position: Tween<Offset>(
                          
                          begin: isInAnimation ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Text(
                    _isMoved
                        ? 'like Airport Transfer, Platinum Service, Business Travel, Silver Taxi Service and so on.'
                        : 'We guarantee for Death, reliable, professional, affordable experience inside of our vehicles.',
                    key: ValueKey<bool>(_isMoved ),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
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
                              
                              Get.toNamed('/login');
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.navigate_next_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
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
      duration: const Duration(milliseconds: 400),
      width: isActive ? 40 : 10,
      height: 5,
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.grey[300],
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
