import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> updateStreak() async {
    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'name': user!.displayName ?? "User",
        'photoUrl': user!.photoURL ?? "",
        'streak': 1,
        'lastActive': DateTime.now().toIso8601String(),
      });
      return;
    }

    final data = doc.data()!;
    final lastActive = DateTime.tryParse(data['lastActive'] ?? "");

    final now = DateTime.now();

    if (lastActive == null || now.difference(lastActive).inHours >= 24) {
      await ref.update({
        'streak': (data['streak'] ?? 0) + 1,
        'lastActive': now.toIso8601String(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateStreak();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Not logged in", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final ref = FirebaseFirestore.instance.collection('users').doc(user!.uid);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Profile"),
        centerTitle: true,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          final name = data?['name'] ?? "User";
          final photo = data?['photoUrl'] ?? "";
          final streak = data?['streak'] ?? 0;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🌟 PROFILE PIC
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black,
                    backgroundImage: photo.isNotEmpty
                        ? NetworkImage(photo)
                        : null,
                    child: photo.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 12),

                // NAME
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 STREAK CARD
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "🔥 Streak:",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$streak days",
                        style: const TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
