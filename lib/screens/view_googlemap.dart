import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewGoogleMapScreen extends StatelessWidget {
  final String location;

  const ViewGoogleMapScreen({super.key, required this.location});

  // Function to open Google Maps with the given location string
  Future<void> _openGoogleMaps(BuildContext context) async {
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location data is missing.")),
      );
      return;
    }

    // Google Maps URL scheme for a search query
    final Uri mapsUri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {'api': '1', 'query': location},
    );

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Location on Map 🗺️"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Reported Location:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  location,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Click the button below to launch the location in your device's Google Maps app.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.map_outlined),
              label: const Text("Open in Google Maps"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () => _openGoogleMaps(context),
            ),
          ],
        ),
      ),
    );
  }
}