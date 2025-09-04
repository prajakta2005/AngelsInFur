import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text(desc),
      ),
    );
  }
}
