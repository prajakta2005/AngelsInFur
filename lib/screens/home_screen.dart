import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';

// Providers
import '../providers/theme_provider.dart';

// Feature Screens
import 'adoption_hub_screen.dart';
import 'emergency_hub_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _blinkController.reverse();
        else if (status == AnimationStatus.dismissed) _blinkController.forward();
      })..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeNotifierProvider);
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'Guardian';

    final features = [
      {'title': 'Emergency Hub', 'desc': 'Report emergencies for NGOs & citizens', 'icon': Icons.report_problem, 'route': 'emergency', 'isEmergency': true},
      {'title': 'Adoption Hub', 'desc': 'Find your forever Angel', 'icon': Icons.pets, 'route': 'adoption'},
      {'title': 'Lost & Found', 'desc': 'Report or find missing animals', 'icon': Icons.search, 'route': 'lostfound'},
      {'title': 'Pet-Care Tips', 'desc': 'Care and warmth for pets', 'icon': Icons.info_outline, 'route': 'tips'},
      {'title': 'Vet Connect', 'desc': 'Book appointments with vets', 'icon': Icons.medical_services, 'route': 'vet'},
      {'title': 'Cat Fun', 'desc': '', 'icon': null, 'route': null, 'isCat': true}, // 6th element with cat animation
    ];

    Widget? _getScreen(String? route) {
      switch (route) {
        case 'adoption': return AdoptionHubScreen();
        case 'emergency': return EmergencyHubScreen();
        default: return null;
      }
    }

    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode ? [Colors.blue[900]!, Colors.purple[800]!] : [Colors.pink[200]!, Colors.purple[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.pets, color: Colors.white, size: 28),
                          const SizedBox(width: 8),
                          Text('AngelsInFur', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white), onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme()),
                          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          }),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Be a Hero for Every Paw! 🐾',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome, $userName', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text('Fur-ever starts here!', style: TextStyle(fontSize: 18, color: textColor)),
                  const SizedBox(height: 24),
                  // Emergency Hub Hero Section
                  if (features.any((f) => f['isEmergency'] == true))
                    GestureDetector(
                      onTap: () {
                        final screen = _getScreen('emergency');
                        if (screen != null) Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
                      },
                      child: AnimatedBuilder(
                        animation: _blinkController,
                        builder: (context, child) {
                          return Card(
                            color: isDarkMode ? Colors.red[800] : Colors.red[100],
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Lottie.asset('assets/siren.json', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error, color: Colors.red);
                                    }),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Emergency Hub', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                                        const SizedBox(height: 4),
                                        Text('Report emergencies', style: TextStyle(fontSize: 16, color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 600.ms);
                        },
                      ),
                    ),
                  // Features Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: features.length,
                    itemBuilder: (context, index) {
                      final feature = features[index];
                      final ConfettiController _confettiController = ConfettiController(duration: Duration(seconds: 1));
                      final ValueNotifier<bool> isHovered = ValueNotifier(false);

                      return ValueListenableBuilder<bool>(
                        valueListenable: isHovered,
                        builder: (context, hovered, child) {
                          return GestureDetector(
                            onTap: () {
                              _confettiController.play();
                              if (feature['route'] != null) {
                                final screen = _getScreen(feature['route'] as String?);
                                if (screen != null) Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
                              }
                            },
                            child: MouseRegion(
                              onEnter: (_) => isHovered.value = true,
                              onExit: (_) => isHovered.value = false,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                transform: Matrix4.identity()..scale(hovered ? 1.05 : 1.0),
                                child: feature['isCat'] == true
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Lottie.asset('assets/cat.json', fit: BoxFit.cover, repeat: true, errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.pets, color: Colors.orange, size: 40);
                                          }),
                                        ),
                                      )
                                    : Card(
                                        color: isDarkMode ? Colors.grey[700] : Colors.teal[50],
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(12.0),
                                          leading: Icon(feature['icon'] as IconData, size: 30, color: textColor),
                                          title: Text(feature['title'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          subtitle: Text(feature['desc'] as String, style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                              ).animate()
                                .fadeIn(duration: 600.ms, delay: (index * 200).ms)
                                .slideY(begin: 0.3, duration: 600.ms, delay: (index * 200).ms),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}