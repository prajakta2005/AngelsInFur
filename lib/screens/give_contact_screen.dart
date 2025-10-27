import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GiveContactScreen extends StatefulWidget {
  final String location;

  const GiveContactScreen({super.key, required this.location});

  @override
  _GiveContactScreenState createState() => _GiveContactScreenState();
}

class _GiveContactScreenState extends State<GiveContactScreen> {
  final TextEditingController _contactController = TextEditingController();

  Future<void> _submitContact() async {
    if (_contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter contact details")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("emergency_contacts").add({
      "location": widget.location,
      "contact": _contactController.text,
      "timestamp": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact submitted successfully")),
    );

    _contactController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Give Contacts")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Provide contact details to help with the emergency."),
            const SizedBox(height: 20),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: "Contact Details (e.g., phone, email)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitContact,
              child: const Text("Submit Contact"),
            ),
            // Long-term: Add verification, user authentication, and notification to NGOs via FCM.
          ],
        ),
      ),
    );
  }
}