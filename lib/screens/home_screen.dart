import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Providers
import '../providers/theme_provider.dart';

// Feature Screens
import 'adoption_hub_screen.dart';
import 'emergency_hub_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider);
    final user = FirebaseAuth.instance.currentUser;

    final userName = user?.displayName ?? 'Guardian!';

    // 🔹 Features List with route keys
    final features = [
      {
        'title': 'Emergency Hub',
        'desc': 'Report emergencies for NGOs & citizens 🚨',
        'icon': Icons.report_problem,
        'route': 'emergency',
      },
      {
        'title': 'Adoption Hub',
        'desc': 'Find your forever Angel 🐶🐱',
        'icon': Icons.pets,
        'route': 'adoption',
      },
      {
        'title': 'Lost & Found',
        'desc': 'Report or find missing animals 👀',
        'icon': Icons.search,
        'route': 'lostfound',
      },
      {
        'title': 'Pet-Care Tips',
        'desc': 'Care and Warmth is what they need 😊',
        'icon': Icons.info_outline,
        'route': 'tips',
      },
      {
        'title': 'Vet Connect',
        'desc': 'Book appointments with nearby vets 🩺',
        'icon': Icons.medical_services,
        'route': 'vet',
      },
      {
        'title': 'Donate',
        'desc': 'Support shelters & animal causes 💝',
        'icon': Icons.volunteer_activism,
        'route': 'donate',
      },
    ];

    // 🔹 Route mapping (easy to scale later)
    Widget? _getScreen(String? route) {
      switch (route) {
        case 'adoption':
          return AdoptionHubScreen();
        case 'emergency':
          return EmergencyHubScreen();
        // Later we’ll add Lost & Found, Vet Connect, etc.
        default:
          return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AngelsInFur 🐾'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $userName 👋',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                "Fur-ever starts here!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 24),
              ...features.asMap().entries.map((entry) {
                final index = entry.key;
                final feature = entry.value;
                return Card(
                  color: Colors.teal.shade50,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Icon(feature['icon'] as IconData, size: 36),
                    title: Text(feature['title'] as String),
                    subtitle: Text(feature['desc'] as String),
                    onTap: () {
                      final screen = _getScreen(feature['route'] as String?);
                      if (screen != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => screen),
                        );
                      }
                    },
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: 600.ms,
                      delay: (index * 200).ms,
                    )
                    .slideY(
                      begin: 0.3,
                      duration: 600.ms,
                      delay: (index * 200).ms,
                    );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
