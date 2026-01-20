import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/rating_controller.dart';
import 'package:kk/map_screen.dart';

class TripCompletedSheet extends StatelessWidget {
      TripCompletedSheet({super.key});

  final RatingController ratingController = Get.put(RatingController());


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ Trip completed row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(image:  AssetImage("assets/images/trip.png"), height: 30),
                      SizedBox(width: 10),
                      Text(
                        "Trip Completed",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  /// 👤 Driver row
                  Center(child: 
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: const [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage("assets/images/driver.png"),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "How would you rate driver",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  ),

                  /// ⭐ Stars
                  Obx(
                    () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          ratingController.setRating(index + 1);
                        },
                        child: Icon(
                          Icons.star,
                          size: 40,
                          color: index < ratingController.rating.value
                              ? Colors.orange
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
              ),
                  
                  const SizedBox(height: 20),

                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your feedback here",
                      ),
                    ),
                  ),

                  const SizedBox(height: 45),

                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),  
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                          
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            Get.offAll( ()=> MyAppleMap());
                          },
                          child: const Text("Submit",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                          
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
