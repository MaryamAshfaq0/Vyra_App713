import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings ⚙️"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text("Dark Mode"),
                trailing: Switch(value: false, onChanged: null),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: Icon(Icons.lock),
                title: Text("Privacy"),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: Icon(Icons.info),
                title: Text("App Version"),
                subtitle: Text("Vyra v1.0"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
