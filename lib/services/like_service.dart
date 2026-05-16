import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';

class LikeService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> toggleLike({
    required String vibeId,
    required String currentUserId,
    required String vibeOwnerId,
    required String currentUserName,
  }) async {
    final docId = "${vibeId}_$currentUserId";
    final likeRef = _db.collection("likes").doc(docId);

    final snapshot = await likeRef.get();

    if (snapshot.exists) {
      await likeRef.delete();
    } else {
      await likeRef.set({
        "vibeId": vibeId,
        "userId": currentUserId,
      });

      if (currentUserId != vibeOwnerId) {
        await NotificationService.createLikeNotification(
          toUserId: vibeOwnerId,
          fromUserName: currentUserName,
        );
      }
    }
  }
}
