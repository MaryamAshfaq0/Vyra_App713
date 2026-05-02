class Vibe {
  final String text;
  final DateTime time;
  final String userEmail;

  Vibe({required this.text, required this.time, required this.userEmail});

  // 🔥 Convert to Firestore
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'time': time.toIso8601String(),
      'userEmail': userEmail,
    };
  }

  // 🔥 Convert from Firestore
  factory Vibe.fromMap(Map<String, dynamic> map) {
    return Vibe(
      text: map['text'] ?? '',
      time: DateTime.parse(map['time']),
      userEmail: map['userEmail'] ?? 'unknown',
    );
  }
}
