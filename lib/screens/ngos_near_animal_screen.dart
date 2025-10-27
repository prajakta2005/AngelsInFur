import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NGOsNearAnimalScreen extends StatelessWidget {
  final String location;

  const NGOsNearAnimalScreen({super.key, required this.location});

  Future<void> _searchNGOs() async {
    final Uri searchUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=animal+ngos+near+$location');
    if (await canLaunchUrl(searchUri)) {
      await launchUrl(searchUri);
    } else {
      // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NGOs Near Animal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Search for animal NGOs near the emergency location."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchNGOs,
              child: const Text("Open NGOs Search on Google Maps"),
            ),
            // Long-term: Integrate a custom database or API for verified NGOs, with contact forms or donation links.
          ],
        ),
      ),
    );
  }
}