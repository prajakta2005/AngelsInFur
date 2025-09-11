import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

// New Screens
import 'vets_near_animal_screen.dart';
import 'ngos_near_animal_screen.dart';
import 'help_financially_screen.dart';
import 'give_contact_screen.dart';
import 'other_help_screen.dart';

class EmergencyHubScreen extends StatefulWidget {
  const EmergencyHubScreen({super.key});

  @override
  State<EmergencyHubScreen> createState() => _EmergencyHubScreenState();
}

class _EmergencyHubScreenState extends State<EmergencyHubScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled. Please enable them.")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permissions are denied.")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permissions are permanently denied. Please enable in settings.")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationController.text = '${position.latitude}, ${position.longitude}';
    });
  }

  Future<void> _submitEmergency() async {
    if (_descriptionController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("emergencies").add({
      "description": _descriptionController.text,
      "location": _locationController.text,
      "timestamp": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Emergency reported successfully 🚨")),
    );

    _descriptionController.clear();
    _locationController.clear();
  }

  // Open Google Maps with location
  Future<void> _openGoogleMaps(String location) async {
    final Uri mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$location');
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps.")),
      );
    }
  }

  // Show options dialog for emergency
  void _showHelpOptions(String location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Help Options"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("View on Google Maps"),
              onTap: () {
                Navigator.pop(context);
                _openGoogleMaps(location);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text("Vets Near Animal"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => VetsNearAnimalScreen(location: location)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("NGOs Near Animal"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => NGOsNearAnimalScreen(location: location)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text("Help Financially"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => HelpFinanciallyScreen(location: location)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text("Give Contacts"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => GiveContactScreen(location: location)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Other Ways to Help"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => OtherHelpScreen(location: location)));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Hub 🚨")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Report Emergency"),
              onPressed: _submitEmergency,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "Reported Emergencies",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("emergencies")
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text("No emergencies reported yet."));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(data["location"] ?? "Unknown location"),
                          subtitle: Text(data["description"] ?? "No description"),
                          trailing: const Icon(Icons.warning, color: Colors.red),
                          onTap: () => _showHelpOptions(data["location"] ?? ""),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}