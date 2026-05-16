import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  final List<Map<String, String>> vibes = const [
    {"user": "Ali", "vibe": "Late night thoughts hit different 🌙"},
    {"user": "Sara", "vibe": "Coffee + coding = happiness ☕"},
    {"user": "Maryam", "vibe": "Building Vyra like a real startup 😏"},
    {"user": "Ayesha", "vibe": "Peace over everything 💜"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explore 🔍"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search vibes...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: vibes.length,
                itemBuilder: (context, index) {
                  final vibe = vibes[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFB388FF),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(vibe["user"]!),
                      subtitle: Text(vibe["vibe"]!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
