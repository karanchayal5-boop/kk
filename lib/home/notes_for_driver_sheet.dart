import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/taxi_controller.dart';

class NotesForDriverSheet extends StatelessWidget {
  final TaxiController taxiController = Get.find();
  NotesForDriverSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(25),
            children: [
              Center(child: Container(width: 40, height: 5, color: Colors.grey[300])),
              const SizedBox(height: 20),
              const Text("Add notes for driver", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(hintText: "Type your message here", fillColor: Colors.grey[100], filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => taxiController.currentStep.value = 0,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D2E32), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => taxiController.currentStep.value = 2,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}