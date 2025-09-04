import 'package:flutter/material.dart';
import 'pet_detail_screen.dart';

class Pet {
  final String name;
  final String breed;
  final int age;
  final String imageUrl;
  final String description;

  Pet({
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.description,
  });
}

class AdoptionHubScreen extends StatelessWidget {
   AdoptionHubScreen({super.key});

  // Dummy Pet Data
  final List<Pet> pets = [
    Pet(
      name: "Bella",
      breed: "Golden Retriever",
      age: 2,
      imageUrl: "https://placedog.net/500?id=1",
      description: "Playful, loves kids, and enjoys running in the park.",
    ),
    Pet(
      name: "Whiskers",
      breed: "Persian Cat",
      age: 3,
      imageUrl: "https://placekitten.com/500/500",
      description: "Calm, affectionate, and perfect for apartment living.",
    ),
     Pet(
      name: "Whiskers",
      breed: "Persian Cat",
      age: 3,
      imageUrl: "https://placekitten.com/500/500",
      description: "Calm, affectionate, and perfect for apartment living.",
    ),
     Pet(
      name: "Whiskers",
      breed: "Persian Cat",
      age: 3,
      imageUrl: "https://placekitten.com/500/500",
      description: "Calm, affectionate, and perfect for apartment living.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adoption Hub 🐾")),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(pet.imageUrl),
                radius: 30,
              ),
              title: Text(pet.name),
              subtitle: Text("${pet.breed}, ${pet.age} yrs"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PetDetailScreen(pet: pet),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
