import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../services/firestore_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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

        title: const Text(
          "Notifications 🔔",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

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
                    Colors.deepPurpleAccent.withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // BOTTOM GLOW
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

          // BLUR
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),

            child: Container(color: Colors.transparent),
          ),

          // REALTIME NOTIFICATIONS
          StreamBuilder<List<NotificationModel>>(
            stream: FirestoreService().getNotifications(),

            builder: (context, snapshot) {
              // LOADING
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ),
                );
              }

              // ERROR
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Something went wrong ❌",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }

              final notifications = snapshot.data ?? [];

              // EMPTY
              if (notifications.isEmpty) {
                return const Center(
                  child: Text(
                    "No notifications yet 🔕",
                    style: TextStyle(color: Colors.white70, fontSize: 17),
                  ),
                );
              }

              // LIST
              return ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: notifications.length,

                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),

                        child: Container(
                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),

                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,

                              colors: [
                                Colors.white.withOpacity(0.08),

                                Colors.white.withOpacity(0.03),
                              ],
                            ),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurpleAccent.withOpacity(
                                  0.12,
                                ),

                                blurRadius: 25,
                                spreadRadius: 1,
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              // ICON
                              Container(
                                height: 60,
                                width: 60,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.deepPurpleAccent,
                                      Colors.purple,
                                    ],
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurpleAccent
                                          .withOpacity(0.5),

                                      blurRadius: 20,
                                    ),
                                  ],
                                ),

                                child: const Icon(
                                  Icons.notifications_active_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 16),

                              // TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      notification.title,

                                      style: const TextStyle(
                                        color: Colors.white,

                                        fontSize: 15,

                                        fontWeight: FontWeight.w600,

                                        height: 1.4,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,

                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,

                                            color: Colors.greenAccent,
                                          ),
                                        ),

                                        const SizedBox(width: 7),

                                        const Text(
                                          "Live notification",

                                          style: TextStyle(
                                            color: Colors.white38,

                                            fontSize: 12,

                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // RIGHT ICON
                              const Icon(
                                Icons.arrow_forward_ios_rounded,

                                color: Colors.white24,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
