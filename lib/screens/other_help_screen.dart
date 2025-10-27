import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherHelpScreen extends StatefulWidget {
  final String location;

  const OtherHelpScreen({super.key, required this.location});

  @override
  _OtherHelpScreenState createState() => _OtherHelpScreenState();
}

class _OtherHelpScreenState extends State<OtherHelpScreen> {
  final TextEditingController _helpController = TextEditingController();

  Future<void> _submitHelp() async {
    if (_helpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter help details")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("emergency_help").add({
      "location": widget.location,
      "help": _helpController.text,
      "timestamp": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Help offer submitted successfully")),
    );

    _helpController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Other Ways to Help")),
      body: Padding(
       padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Suggest other ways to help, e.g., volunteer or supplies."),
            const SizedBox(height: 20),
            TextField(
              controller: _helpController,
              decoration: const InputDecoration(labelText: "Help Details"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitHelp,
              child: const Text("Submit Help"),
            ),
            // Long-term: Add categories (volunteer, supplies), matching with AI (GenAI for recommendation), and real-time matching with users/NGOs.
          ],
        ),
      ),
    );
  }
}