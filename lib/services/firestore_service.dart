import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vibe.dart';

class FirestoreService {
  final CollectionReference vibes = FirebaseFirestore.instance.collection(
    'vibes',
  );

  //ADD VIBE
  Future<void> addVibe(Vibe vibe) async {
    await vibes.add(vibe.toMap());
  }

  //REAL-TIME STREAM
  Stream<List<Vibe>> getVibes() {
    return vibes.orderBy('time', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Vibe.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
