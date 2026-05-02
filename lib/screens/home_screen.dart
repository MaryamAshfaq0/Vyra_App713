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
      appBar: AppBar(title: const Text("Vyra 💜"), centerTitle: true),

      body: StreamBuilder<List<Vibe>>(
        stream: FirestoreService().getVibes(),
        builder: (context, snapshot) {
          // 🔄 Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong ❌"));
          }

          final vibes = snapshot.data ?? [];

          // Empty state
          if (vibes.isEmpty) {
            return const Center(child: Text("No vibes yet 😔"));
          }

          // REAL FEED
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vibes.length,
            itemBuilder: (context, index) {
              final vibe = vibes[index];

              return VibeCard(name: vibe.userEmail, vibe: vibe.text);
            },
          );
        },
      ),
    );
  }
}
