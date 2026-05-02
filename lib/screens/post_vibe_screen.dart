import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vibe_provider.dart';

class PostVibeScreen extends StatefulWidget {
  const PostVibeScreen({super.key});

  @override
  State<PostVibeScreen> createState() => _PostVibeScreenState();
}

class _PostVibeScreenState extends State<PostVibeScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share Your Vibe")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ✨ Premium Input Box
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
                decoration: const InputDecoration(
                  hintText: "How are you feeling today?",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Gradient Button
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    Provider.of<VibeProvider>(
                      context,
                      listen: false,
                    ).addVibe(controller.text);

                    Navigator.pop(context);
                  }
                },
                child: const Text("Post Vibe", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
