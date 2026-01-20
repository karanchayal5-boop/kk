import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/taxi_controller.dart';

class DriverArrivingSheet extends StatelessWidget {
  const DriverArrivingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TaxiController taxiController = Get.find();

    return Stack(
      children: [
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.44,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${taxiController.estimatedTimeMin.value} Mins",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// ================= BOTTOM SHEET =================
        DraggableScrollableSheet(
          initialChildSize: 0.42,
          minChildSize: 0.42,
          maxChildSize: 0.42,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(1)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),

                  /// ================= DRIVER INFO =================
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage("assets/images/driver.png"),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Mr. Joe",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 18),
                              Icon(Icons.star, color: Colors.orange, size: 18),
                              Icon(Icons.star, color: Colors.orange, size: 18),
                              Icon(Icons.star, color: Colors.orange, size: 18),
                              Icon(Icons.star, color: Colors.grey, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "(26 ratings)",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Divider(height: 1),
                  const SizedBox(height: 10),

                  /// ================= CAR CARD (XD PERFECT) =================
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Honda City",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:  FontWeight.bold,
                              
                            ),
                          ),
                          Spacer(),
                          Text(
                            "First Available",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 110,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 25,
                              bottom: 25,
                              left: 50,
                              right: 15,
                              child: Container(
                                height: 80,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: const [
                                    Spacer(),
                                    Text(
                                      "T3479",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 1,
                              child: Image.asset(
                                "assets/images/sedan@3x.png",
                                height: 95,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                  const Divider(),

                  /// ================= BUTTONS =================
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: const [
                              Icon(Icons.close, size: 28),
                              SizedBox(height: 6),
                              Text("Cancel"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: const [
                              Icon(Icons.call, size: 28),
                              SizedBox(height: 6),
                              Text("Call Driver"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
