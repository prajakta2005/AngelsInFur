import 'package:flutter/material.dart';
import 'adoption_hub_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                pet.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              pet.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "${pet.breed}, ${pet.age} yrs old",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Text(
              pet.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("You showed interest in adopting ${pet.name}!")),
                );
              },
              icon: const Icon(Icons.pets),
              label: const Text("Adopt Me 💕"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
