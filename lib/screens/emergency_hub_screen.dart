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
import 'view_googlemap.dart'; // <-- NEW IMPORT

class EmergencyHubScreen extends StatefulWidget {
  const EmergencyHubScreen({super.key});

  @override
  State<EmergencyHubScreen> createState() => _EmergencyHubScreenState();
}

class _EmergencyHubScreenState extends State<EmergencyHubScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // State to manage loading status of location fetching
  bool _isFetchingLocation = false;

  Future<void> _fetchCurrentLocation() async {
    if (mounted) {
      setState(() {
        _isFetchingLocation = true;
      });
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location services are disabled. Please enable them.")),
        );
        setState(() => _isFetchingLocation = false); // Stop loading
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permissions are denied.")),
          );
          setState(() => _isFetchingLocation = false); // Stop loading
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permissions are permanently denied. Please enable in settings.")),
        );
        setState(() => _isFetchingLocation = false); // Stop loading
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _locationController.text = '${position.latitude}, ${position.longitude}';
          _isFetchingLocation = false; // Stop loading
        });
      }
    } catch (e) {
      // Handle any other errors during position fetching
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to get location: $e")),
        );
        setState(() => _isFetchingLocation = false); // Stop loading
      }
    }
  }

  Future<void> _submitEmergency() async {
    if (_descriptionController.text.isEmpty || _locationController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")),
        );
      }
      return;
    }

    await FirebaseFirestore.instance.collection("emergencies").add({
      "description": _descriptionController.text,
      "location": _locationController.text,
      "timestamp": FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Emergency reported successfully 🚨")),
      );
    }

    _descriptionController.clear();
    _locationController.clear();
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
                // NAVIGATION: Push to the new ViewGoogleMapScreen
                Navigator.push(context, MaterialPageRoute(builder: (_) => ViewGoogleMapScreen(location: location)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text("Vets Near Animal"),
              onTap: () {
                Navigator.pop(context);
                // NAVIGATION: Push to VetsNearAnimalScreen
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
    // Fetch location automatically on start
    _fetchCurrentLocation();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Hub 🚨")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row for Location Field and Get Location Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: "Location (Lat, Lon or Address)",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _isFetchingLocation
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.my_location),
                        tooltip: 'Get Current Location',
                        onPressed: _fetchCurrentLocation,
                      ),
              ],
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description of Emergency"),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("emergencies")
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No emergencies reported yet."));
                  }

                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>; 
                      final location = data["location"] as String? ?? "Unknown location";
                      final description = data["description"] as String? ?? "No description";
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(location),
                          subtitle: Text(description),
                          trailing: const Icon(Icons.warning, color: Colors.red),
                          onTap: () => _showHelpOptions(location),
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