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
      final vibe = Vibe(
        text: text,
        userEmail: user?.email ?? "unknown",
        time: DateTime.now(),
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
        ).showSnackBar(const SnackBar(content: Text("Error posting vibe ❌")));
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share Your Vibe")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ✨ Input Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "How are you feeling today?",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : postVibe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Post Vibe", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
