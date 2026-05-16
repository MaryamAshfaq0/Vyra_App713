import 'dart:ui';

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/onesignal_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final AuthService auth = AuthService();

  // LOGIN
  void login() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Please fill all fields");
      return;
    }

    final user = await auth.login(email, password);

    if (user != null) {
      //ONE SIGNAL ADD
      OneSignalService.setUser(user.uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      showMessage("Login Failed ❌");
    }
  }

  // SIGNUP
  void signup() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage("Please fill all fields");
      return;
    }

    final user = await auth.signUp(email, password);

    if (user != null) {
      // ONE SIGNAL ADD
      OneSignalService.setUser(user.uid);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      showMessage("Signup Failed ❌");
    }
  }

  // SNACKBAR
  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.deepPurpleAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(msg, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          // TOP GLOW
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
                    Colors.deepPurpleAccent.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // BOTTOM GLOW
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              height: 320,
              width: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // BLUR BACKGROUND
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // LOGO
                    Hero(
                      tag: "logo",
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 105,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // TITLE
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.deepPurpleAccent,
                          ],
                        ).createShader(bounds);
                      },
                      child: const Text(
                        "Vyra",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Connect. Share. Feel the vibe.",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 55),

                    // FORM BOX
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Column(
                            children: [
                              // EMAIL
                              TextField(
                                controller: emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Email Address",
                                  hintStyle: TextStyle(color: Colors.white38),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white54,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // PASSWORD
                              TextField(
                                controller: passController,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.white38),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white54,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),

                              const SizedBox(height: 35),

                              // LOGIN BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                  ),
                                  child: const Text("LOGIN"),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // SIGNUP
                              TextButton(
                                onPressed: signup,
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
