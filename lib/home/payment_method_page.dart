import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/taxi_controller.dart';
import 'package:pay/pay.dart';

class PaymentMethodPage extends StatelessWidget {
  PaymentMethodPage({super.key});

  final TaxiController taxiController = Get.put(TaxiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 22,
              ),
            ),
          ),
        ),
        title: const Text(
          "Payment method",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: const [
                    Icon(Icons.person, color: Colors.grey),
                    SizedBox(width: 8),
                    Text("Personal", style: TextStyle(color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 12),

                _cardTile("xxxx xxxx 4793", 0, Colors.blue),
                const Divider(),
                _cardTile("xxxx xxxx 3525", 1, Colors.blue),

                const SizedBox(height: 10),

                _addTile("Add personal card"),

                const SizedBox(height: 25),

                Row(
                  children: const [
                    Icon(Icons.work, color: Colors.grey),
                    SizedBox(width: 8),
                    Text("Business", style: TextStyle(color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 12),

                _cardTile("xxxx xxxx 4793", 2, Colors.orange),

                const SizedBox(height: 10),

                _addTile("Add business card"),

                const SizedBox(height: 25),

                Row(
                  children: const [
                    Icon(Icons.card_giftcard, color: Colors.grey),
                    SizedBox(width: 8),
                    Text("Promo code", style: TextStyle(color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 12),

                _addTile("Add promo code"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(70),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: applePayButton([
                PaymentItem(
                  label: 'Total',
                  amount: '10.00',
                  status: PaymentItemStatus.final_price,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTile(String text, int index, Color iconColor) {
    return Obx(() {
      bool selected = taxiController.selectedPaymentIndex.value == index;

      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.credit_card, color: iconColor),
        title: Text(text, style: const TextStyle(fontSize: 16)),
        trailing: selected
            ? const Icon(Icons.check, color: Colors.orange, size: 22)
            : null,
        onTap: () {
          taxiController.selectedPaymentIndex.value = index;
          taxiController.selectedCardText.value = text;
        },
      );
    });
  }

  Widget _addTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.add, color: Colors.black),
      title: Text(title),
      onTap: () {},
    );
  }
}

Widget applePayButton(List<PaymentItem> _paymentItems) {
  return ApplePayButton(
    // Apple Pay ka ready-made button
    paymentConfigurationAsset: 'apple_pay.json', // config file ka path
    paymentItems: _paymentItems, // payment details
    style: ApplePayButtonStyle.black, // button style
    type: ApplePayButtonType.buy, // button text type
    margin: const EdgeInsets.only(top: 10),

    onPaymentResult: (result) {
      print(result); // payment ka response yaha milega
    },

    loadingIndicator: const Center(
      child: CircularProgressIndicator(), // jab load ho raha ho
    ),
  );
}
