import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vibe.dart';
import '../models/notification_model.dart';

class FirestoreService {
  // ================= COLLECTIONS =================

  final CollectionReference vibes = FirebaseFirestore.instance.collection(
    'vibes',
  );

  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');

  // ================= ADD VIBE =================

  Future<void> addVibe(Vibe vibe) async {
    await vibes.add(vibe.toMap());
  }

  // ================= REALTIME VIBES =================

  Stream<List<Vibe>> getVibes() {
    return vibes.orderBy('time', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Vibe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // ================= LIKE VIBE (PRODUCTION FIXED) =================

  Future<void> likeVibe(
    String vibeId,
    String fromUserEmail,
    String toUserEmail,
  ) async {
    final vibeRef = vibes.doc(vibeId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      //  atomic like increment
      transaction.update(vibeRef, {'likes': FieldValue.increment(1)});

      //  create notification
      final notifRef = notifications.doc();

      transaction.set(notifRef, {
        'title': "$fromUserEmail liked your vibe ❤️",
        'toUser': toUserEmail,
        'fromUser': fromUserEmail,
        'vibeId': vibeId,
        'type': 'like',
        'time': FieldValue.serverTimestamp(),
        'seen': false,
      });
    });
  }

  // ================= UNLIKE VIBE =================

  Future<void> unlikeVibe(String vibeId, String fromUserEmail) async {
    await vibes.doc(vibeId).update({'likes': FieldValue.increment(-1)});
  }

  // ================= REALTIME NOTIFICATIONS =================

  Stream<List<NotificationModel>> getNotifications() {
    return notifications.orderBy('time', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
