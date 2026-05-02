import 'package:flutter/material.dart';

class VibeCard extends StatelessWidget {
  final String name;
  final String vibe;

  const VibeCard({super.key, required this.name, required this.vibe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(name[0], style: const TextStyle(color: Colors.purple)),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(vibe, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          const Icon(Icons.favorite_border, color: Colors.white),
        ],
      ),
    );
  }
}
