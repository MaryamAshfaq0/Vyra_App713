class NotificationModel {
  final String title;
  final DateTime time;

  NotificationModel({required this.title, required this.time});

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? '',
      time: DateTime.parse(map['time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'time': time.toIso8601String()};
  }
}
