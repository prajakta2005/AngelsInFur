import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PetCareScreen extends StatelessWidget {
  const PetCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the data for the tabs
    final List<Map<String, dynamic>> careTopics = [
      {
        'title': 'Nutrition & Diet 🍎',
        'icon': Icons.local_dining,
        'color': Colors.orange.shade300,
        'tips': [
          {'title': 'Balanced Meals', 'desc': 'Ensure food is complete and balanced for their life stage.'},
          {'title': 'Avoid Toxins', 'desc': 'Keep chocolate, grapes, onions, and xylitol far away.'},
          {'title': 'Fresh Water', 'desc': 'Always provide access to clean, fresh water.'},
        ],
      },
      {
        'title': 'Health & Hygiene 🩺',
        'icon': Icons.healing,
        'color': Colors.blue.shade300,
        'tips': [
          {'title': 'Regular Vet Visits', 'desc': 'Schedule check-ups at least once a year.'},
          {'title': 'Vaccinations', 'desc': 'Keep vaccinations and deworming up-to-date.'},
          {'title': 'Dental Care', 'desc': 'Brush teeth regularly or use dental chews.'},
        ],
      },
      {
        'title': 'Exercise & Play 🤸',
        'icon': Icons.sports_tennis,
        'color': Colors.green.shade300,
        'tips': [
          {'title': 'Daily Activity', 'desc': 'Ensure 30-60 minutes of exercise based on breed.'},
          {'title': 'Mental Stimulation', 'desc': 'Use puzzle toys and rotation to keep them engaged.'},
          {'title': 'Safe Space', 'desc': 'Provide a secure yard or indoor area for play.'},
        ],
      },
    ];

    return DefaultTabController(
      length: careTopics.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pet-Care Tips 💖'),
          backgroundColor: Colors.pink,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: careTopics.map((topic) {
              return Tab(
                icon: Icon(topic['icon'] as IconData),
                text: topic['title'] as String,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: careTopics.map((topic) {
            final tipsList = topic['tips'] as List<Map<String, String>>;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: tipsList.length,
              itemBuilder: (context, index) {
                final tip = tipsList[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: topic['color'] as Color,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.star, color: Colors.white, size: 30),
                    title: Text(
                      tip['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      tip['desc']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                )
                // Aesthetic animation using flutter_animate
                .animate()
                .fadeIn(duration: 600.ms, delay: (index * 150).ms)
                .slideX(begin: 0.1, duration: 600.ms, delay: (index * 150).ms);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}