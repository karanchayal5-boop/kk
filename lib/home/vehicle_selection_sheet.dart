import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kk/controller/taxi_controller.dart';
import 'package:kk/home/payment_method_page.dart';

class VehicleSelectionSheet extends StatelessWidget {
  final TaxiController taxiController = Get.find();

  VehicleSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(1)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              const SizedBox(height: 10),

              const Text(
                "You will reach by 12:44 PM",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 15),

              _vehicleCard("First Available", "4 Seater", "\$64", 0, "assets/images/firsr_available@3x.png"),
              const SizedBox(height: 5),
              _vehicleCard("Sedan", "4 Seater", "\$45", 1, "assets/images/sedan@3x.png"),

              const SizedBox(height: 10),

              _buildPaymentInfo(context),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () => taxiController.currentStep.value = 1,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  

  Widget _vehicleCard(String title, String subtitle, String price, int index, String imagepath) {
    return Obx(() {
      final isSelected = taxiController.selectedVehicleIndex.value == index;
      return GestureDetector(
        onTap: () => taxiController.selectedVehicleIndex.value = index,
        child: Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 10, left: 40),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 60, right: 15, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(subtitle, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.lock_outline, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isSelected ? Colors.orange : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: -45,
                top: 10,
                child: Image.asset(imagepath, width: 110),
              )
            ],
          ),
        ),
      );
    });
  }

  

  Widget _buildPaymentInfo(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Payment",
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      const SizedBox(height: 4),

      Row(
        children: [
          const Text(
            "xxxx xxxx 4793",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: () {
              Get.to(()=> PaymentMethodPage());
            },
            child: Text("Change", style: TextStyle(color: Colors.orange[900])),
          ),

          const Spacer(),

          GestureDetector(
            onTap: () 
              => showIOSSchedulePicker(context),
            
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month, size: 18),
                const SizedBox(width: 5),

                Obx(() {
                  final dt = taxiController.scheduledDateTime.value;

                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      "${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}


  

  void showIOSSchedulePicker(BuildContext context) {
    DateTime tempDate = taxiController.scheduledDateTime.value.isAfter(DateTime.now())
        ? taxiController.scheduledDateTime.value
        : DateTime.now().add(const Duration(minutes: 10));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: 420,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),

              const Text("Schedule for later", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("You can book up to 7-days in advance.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),

              Text(
                "${_formatDate(tempDate)} | ${_formatTime(tempDate)}",
                style: const TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const Divider(),

              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: tempDate,
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime.now().add(const Duration(days: 7)),
                  use24hFormat: false,
                  onDateTimeChanged: (dt) => tempDate = dt,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          taxiController.scheduledDateTime.value = tempDate;
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text("Book", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  

  static String _formatDate(DateTime dt) {
    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    const days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    return "${days[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]}";
  }

  static String _formatTime(DateTime dt) {
    int hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final isPM = hour >= 12;
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return "$hour:$minute ${isPM ? "PM" : "AM"}";
  }
}
