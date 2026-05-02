import 'package:flutter/material.dart';
import 'post_vibe_screen.dart';
import 'profile_screen.dart';
import '../services/firestore_service.dart';
import '../models/vibe.dart';
import '../widgets/vibe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [FeedScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostVibeScreen()),
          );
        },
      ),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vyra 💜")),

      // FIREBASE REAL-TIME FEED
      body: StreamBuilder<List<Vibe>>(
        stream: FirestoreService().getVibes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final vibes = snapshot.data!;

          if (vibes.isEmpty) {
            return const Center(child: Text("No vibes yet 😔"));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              itemCount: vibes.length,
              itemBuilder: (context, index) {
                final vibe = vibes[index];

                return VibeCard(
                  name: vibe.userEmail, // user
                  vibe: vibe.text,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
