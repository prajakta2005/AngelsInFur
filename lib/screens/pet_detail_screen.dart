import 'package:flutter/material.dart';
import 'adoption_form_screen.dart';
import '../models/pet_model.dart'; // Ensure this import is correct

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = ModalRoute.of(context)!.settings.arguments as Pet;

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        backgroundColor: Colors.purple[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(pet.imageUrl),
                radius: 80,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text("Name: ${pet.name}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Breed: ${pet.breed}", style: const TextStyle(fontSize: 18)),
            Text("Age: ${pet.age} yrs", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text(pet.description, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/adoption-form',
                    arguments: pet,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Adopt Me!", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}