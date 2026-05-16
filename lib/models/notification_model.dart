class NotificationModel {
  final String title;
  final String type;

  NotificationModel({
    required this.title,
    required this.type,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? '',
      type: map['type'] ?? '',
    );
  }
}
