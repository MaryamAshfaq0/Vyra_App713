import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'post_vibe_screen.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

import '../services/firestore_service.dart';
import '../models/vibe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FeedScreen(),
    ExploreScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: _screens[_currentIndex],
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purple],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.4),
              blurRadius: 20,
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostVibeScreen()),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.deepPurpleAccent,
              unselectedItemColor: Colors.white38,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "Feed",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_rounded),
                  label: "Explore",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_rounded),
                  label: "Alerts",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////
// FEED SCREEN
//////////////////////////////////////////////////////////////////

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.white.withOpacity(0.03)),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 32),
            const SizedBox(width: 10),
            const Text(
              "Vyra",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.deepPurpleAccent.withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            right: -100,
            child: Container(
              height: 320,
              width: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.purple.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(color: Colors.transparent),
          ),
          StreamBuilder<List<Vibe>>(
            stream: FirestoreService().getVibes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Something went wrong ❌",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final vibes = snapshot.data ?? [];

              if (vibes.isEmpty) {
                return const Center(
                  child: Text(
                    "No vibes yet 😔",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vibes.length,
                itemBuilder: (context, index) {
                  final vibe = vibes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: DarkVibeCard(vibe: vibe),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////
// VIBE CARD
//////////////////////////////////////////////////////////////////

class DarkVibeCard extends StatefulWidget {
  final Vibe vibe;

  const DarkVibeCard({super.key, required this.vibe});

  @override
  State<DarkVibeCard> createState() => _DarkVibeCardState();
}

class _DarkVibeCardState extends State<DarkVibeCard> {
  bool isLiked = false;
  late int likes;

  @override
  void initState() {
    super.initState();
    likes = widget.vibe.likes;
  }

  Future<void> _toggleLike() async {
    final service = FirestoreService();

    final currentUserEmail =
        FirebaseAuth.instance.currentUser?.email ?? "Unknown User";

    setState(() {
      isLiked = !isLiked;

      if (isLiked) {
        likes++;
      } else {
        likes--;
      }
    });

    try {
      if (isLiked) {
        await service.likeVibe(
          widget.vibe.id,
          currentUserEmail,
          widget.vibe.userEmail,
        );
      } else {
        await service.unlikeVibe(
          widget.vibe.id,
          currentUserEmail,
        );
      }
    } catch (e) {
      setState(() {
        if (isLiked) {
          likes--;
        } else {
          likes++;
        }

        isLiked = !isLiked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong ❌"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.vibe.userEmail,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.more_horiz, color: Colors.white54),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                widget.vibe.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: _toggleLike,
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.pinkAccent : Colors.white54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$likes",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 22),
                  const Icon(Icons.chat_bubble_outline, color: Colors.white54),
                  const Spacer(),
                  const Icon(Icons.bookmark_border, color: Colors.white54),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
