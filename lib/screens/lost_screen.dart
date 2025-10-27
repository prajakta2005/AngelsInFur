import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
// NEW IMPORTS for image handling
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LostScreen extends StatefulWidget {
  const LostScreen({super.key});

  @override
  State<LostScreen> createState() => _LostScreenState();
}

class _LostScreenState extends State<LostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();

  File? _pickedImage;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_pickedImage == null) return null;

    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('lost_pet_images')
        .child('$userId-$timestamp.jpg');

    try {
      await storageRef.putFile(_pickedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate() || _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a photo.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final imageUrl = await _uploadImage();

    if (imageUrl == null) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image. Please try again.')),
      );
      return;
    }

    try {
      // NOTE: Using Firebase server timestamp is fine; the Firestore query itself is what was restricted.
      await FirebaseFirestore.instance.collection('lost_reports').add({
        'petName': _petNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'contact': _contactController.text.trim(),
        'status': 'Lost',
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(), 
        'imageUrl': imageUrl, 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lost pet report submitted! 🐾')),
      );

      _petNameController.clear();
      _descriptionController.clear();
      _contactController.clear();
      setState(() {
        _pickedImage = null;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _markFound(String docId) async {
    await FirebaseFirestore.instance
        .collection('lost_reports')
        .doc(docId)
        .update({'status': 'Found'});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Status updated to Found ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found 🐾'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form Section
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _petNameController,
                    decoration: const InputDecoration(
                      labelText: 'Pet Name',
                      prefixIcon: Icon(Icons.pets),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter pet name' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (Breed, Color, Area, etc.)',
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter description' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _contactController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Info',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter contact info' : null,
                  ),
                  const SizedBox(height: 12),

                  // Image Picker Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton.icon(
                      onPressed: _pickImage,
                      icon: _pickedImage == null
                          ? const Icon(Icons.camera_alt)
                          : const Icon(Icons.check_circle, color: Colors.green),
                      label: Text(
                        _pickedImage == null
                            ? 'Select Pet Photo (Required)'
                            : 'Photo Selected! Ready to submit.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Display selected image thumbnail
                  if (_pickedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _pickedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitReport,
                    icon: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send),
                    label: Text(_isSubmitting ? 'Submitting...' : 'Submit Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const Divider(height: 30, thickness: 1),
                ],
              ),
            ),
            // List Section
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('lost_reports')
                    // ⚠️ REMOVED .orderBy('timestamp', descending: true) to avoid Composite Index requirement
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading reports.'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text('No lost pets reported yet 🐕'));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final report = docs[index];
                      final petName = report['petName'];
                      final desc = report['description'];
                      final contact = report['contact'];
                      final status = report['status'];
                      final docId = report.id;
                      final imageUrl = report['imageUrl'] as String?; 

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          // Leading Widget with Image
                          leading: imageUrl != null && imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                    },
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline),
                                  ),
                                )
                              : const Icon(Icons.pets, size: 40, color: Colors.teal), // Fallback icon
                          
                          title: Text('$petName (${status})',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: status == 'Found'
                                    ? Colors.green
                                    : Colors.redAccent,
                              )),
                          subtitle: Text('$desc\nContact: $contact'),
                          isThreeLine: true,
                          trailing: status == 'Lost'
                              ? TextButton(
                                  onPressed: () => _markFound(docId),
                                  child: const Text('Mark Found'),
                                )
                              : const Icon(Icons.check_circle,
                                  color: Colors.green),
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