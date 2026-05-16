import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createLikeNotification({
    required String toUserId,
    required String fromUserName,
  }) async {
    await _db.collection("notifications").add({
      "title": "$fromUserName liked your vibe ❤️",
      "toUserId": toUserId,
      "type": "like",
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}
