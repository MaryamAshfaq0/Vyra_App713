class Vibe {
  final String id;
  final String text;
  final DateTime time;
  final String userEmail;
  final int likes;

  Vibe({
    required this.id,
    required this.text,
    required this.time,
    required this.userEmail,
    required this.likes,
  });

  factory Vibe.fromMap(Map<String, dynamic> map, String docId) {
    return Vibe(
      id: docId,
      text: map['text'] ?? '',
      time: DateTime.parse(map['time']),
      userEmail: map['userEmail'] ?? '',
      likes: map['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'time': time.toIso8601String(),
      'userEmail': userEmail,
      'likes': likes,
    };
  }
}
