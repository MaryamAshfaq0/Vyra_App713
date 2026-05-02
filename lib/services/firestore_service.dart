import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vibe.dart';

class FirestoreService {
  final CollectionReference vibes = FirebaseFirestore.instance.collection(
    'vibes',
  );

  Future<void> addVibe(Vibe vibe) async {
    await vibes.add(vibe.toMap());
  }

  Stream<List<Vibe>> getVibes() {
    return vibes.orderBy('time', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Vibe.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
