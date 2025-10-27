import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
//import 'pet_detail_screen.dart';
//import 'adoption_form_screen.dart';
import '../models/pet_model.dart'; // Ensure this import is correct

class AdoptionHubScreen extends StatelessWidget {
  AdoptionHubScreen({super.key});

  final List<Pet> pets = [
     Pet(
      name: "Oreo",
      breed: "Stray Cat",
      age: 2,
      imageUrl: "https://media.istockphoto.com/id/1204283308/photo/stray-black-white-cat-with-green-eyes-sitting-down-on-sidewalk-pavement-driveway-street-in.jpg?s=1024x1024&w=is&k=20&c=5Bo73feCNG3NBz8I-umTmlgJY1TEE-2lWd_fCwfPk50=",
      description: "Playful, loves kids, and enjoys running in the park!",
    ),
    Pet(
      name: "CoCo",
      breed: "Indie Stray Dog",
      age: 1,
      imageUrl: "https://www.istockphoto.com/photos/stray-white-dog",
      description: "Calm, affectionate, and perfect for apartment living!",
    ),
    Pet(
      name: "Luna",
      breed: "Stray Cat",
      age: 3,
      imageUrl: "https://media.istockphoto.com/id/1250103419/photo/small-kitten-in-a-shelter-cage.jpg?s=1024x1024&w=is&k=20&c=54PwFPJux33KeBGZJW7852Rm_7n3UA0AR0puLuPg9_0=",
      description: "Silent, Playful and jolly angel",
    ),
    Pet(
      name: "Simba",
      breed: "Stray Dog",
      age: 3,
      imageUrl: "https://media.istockphoto.com/id/1205919904/photo/puppy-dachshund-looks-at-the-camera.jpg?s=1024x1024&w=is&k=20&c=YL0KTPGIN_8vrb7dJ02xc1ztMVvvAFlVURAsFDUPEdY=",
      description: "Calm, affectionate, and perfect for apartment living!",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const double adoptionProgress = 0.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Adoption Hub 🐾", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 240, 98, 146), Color.fromARGB(255, 171, 71, 188)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 6,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: LinearProgressIndicator(
              value: adoptionProgress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 10,
            ),
          ),
          Text(
            "Adoption Progress: ${(adoptionProgress * 100).toStringAsFixed(0)}%",
            style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              final ConfettiController confettiController = ConfettiController(duration: const Duration(seconds: 1));

              return GestureDetector(
                onTap: () {
                  confettiController.play();
                  Navigator.pushNamed(
                    context,
                    '/pet-detail',
                    arguments: pet,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  color: Colors.teal[50],
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(pet.imageUrl),
                      radius: 30,
                      backgroundColor: Colors.white,
                    ),
                    title: Text(pet.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                    subtitle: Row(
                      children: [
                        Text("${pet.breed}, ", style: TextStyle(fontSize: 14, color: Colors.black54)),
                        const Icon(Icons.cake, size: 14, color: Colors.amber),
                        Text("${pet.age} yrs", style: TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                    trailing: const Icon(Icons.pets, color: Colors.green, size: 24),
                    tileColor: Colors.transparent,
                  ).animate()
                    .fadeIn(duration: 600.ms, delay: (index * 200).ms)
                    .scaleXY(begin: 0.9, end: 1.0, duration: 600.ms, delay: (index * 200).ms)
                    .then()
                    .moveY(begin: 10, end: 0, duration: 400.ms, curve: Curves.easeOut),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
