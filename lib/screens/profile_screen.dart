import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vibe_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vibeProvider = Provider.of<VibeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✨ Gradient Avatar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
                ),
              ),
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "You",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "🔥 ${vibeProvider.streak} day streak",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
