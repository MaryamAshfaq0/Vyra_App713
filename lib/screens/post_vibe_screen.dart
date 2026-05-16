import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vibe.dart';
import '../services/firestore_service.dart';

class PostVibeScreen extends StatefulWidget {
  const PostVibeScreen({super.key});

  @override
  State<PostVibeScreen> createState() => _PostVibeScreenState();
}

class _PostVibeScreenState extends State<PostVibeScreen> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;

  Future<void> postVibe() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() => isLoading = true);

    final user = FirebaseAuth.instance.currentUser;

    try {
      // Create vibe objectand save to Firestore
      final vibe = Vibe(
        id: '', // Firestore will generate automatically
        text: text,
        userEmail: user?.email ?? "unknown",
        time: DateTime.now(),
        likes: 0,
      );

      await FirestoreService().addVibe(vibe);

      controller.clear();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Vibe posted 💜")));

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error posting vibe")));
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Share Your Vibe"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // INPUT BOX
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                controller: controller,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "How are you feeling today?",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : postVibe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 178, 168, 205),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 62, 4, 84))
                    : const Text("Post Vibe", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
