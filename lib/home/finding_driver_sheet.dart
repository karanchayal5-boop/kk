import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/taxi_controller.dart';

 class FindingDriverSheet extends StatefulWidget {
  const FindingDriverSheet({super.key});

  @override
  State<FindingDriverSheet> createState() => _FindingDriverSheetState();
}

class _FindingDriverSheetState extends State<FindingDriverSheet> {
  final TaxiController taxiController = Get.find();

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 2), () {
      taxiController.currentStep.value = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.25,
      maxChildSize: 0.35,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              const Text(
                "Searching nearby cabs...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              const LinearProgressIndicator(
                backgroundColor: Color(0xFFEEEEEE),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
                minHeight: 4,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => taxiController.currentStep.value = 1,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2E32),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Cancel Ride",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
