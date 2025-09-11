import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VetsNearAnimalScreen extends StatelessWidget {
  final String location;

  const VetsNearAnimalScreen({super.key, required this.location});

  Future<void> _searchVets() async {
    final Uri searchUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=vets+near+$location');
    if (await canLaunchUrl(searchUri)) {
      await launchUrl(searchUri);
    } else {
      // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vets Near Animal")),
      body: Padding(
       padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Search for vets near the emergency location."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchVets,
              child: const Text("Open Vets Search on Google Maps"),
            ),
            // Long-term: Integrate Google Places API for in-app list of vets with ratings, contacts, etc.
          ],
        ),
      ),
    );
  }
}