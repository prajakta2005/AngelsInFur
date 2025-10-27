import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VetsNearAnimalScreen extends StatelessWidget {
  final String location;

  const VetsNearAnimalScreen({super.key, required this.location});

  Future<void> _searchVets(BuildContext context) async {
    // Correct query: search for "veterinarian" near the location provided
    final String query = Uri.encodeComponent("veterinarian near $location");
    
    // Correct URI construction for Google Maps search
    final Uri searchUri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {'api': '1', 'query': query},
    );

    if (await canLaunchUrl(searchUri)) {
      // Use externalApplication mode to properly open a map/browser app
      await launchUrl(searchUri, mode: LaunchMode.externalApplication);
    } else {
      // Error handling using the current screen's context
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open external search app.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vets Near Animal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // To make the button full width
          children: [
            const Text(
              "Emergency Location:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              location,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "Click the button below to search for nearby veterinarians on Google Maps.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("Open Vets Search on Google Maps"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () => _searchVets(context), // Pass context to the async function
            ),
            // Long-term: Integrate Google Places API for in-app list of vets with ratings, contacts, etc.
          ],
        ),
      ),
    );
  }
}