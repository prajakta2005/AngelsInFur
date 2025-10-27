import 'package:flutter/material.dart';

class HelpFinanciallyScreen extends StatelessWidget {
  final String location;

  const HelpFinanciallyScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help Financially")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Contribute financially to help the animal in this emergency."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Integrate Razorpay or Stripe here for payments
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment integration coming soon!")),
                );
              },
              child: const Text("Donate Now"),
            ),
            // Long-term: Add payment gateway, amount selection, and receipt generation with Firestore logging.
          ],
        ),
      ),
    );
  }
}