class Notif {
  final String type;
  final String profilePhoto;
  final String name;
  final String notification;
  final String id;
  final int notificationId;
  final bool isSupporter;

  Notif(
      {this.type,
      this.profilePhoto,
      this.name,
      this.notification,
      this.id,
      this.notificationId,
      this.isSupporter});

  factory Notif.fromJson(Map<String, dynamic> json) {
    return Notif(
        type: json['type'],
        profilePhoto: json['profile_photo'],
        name: json['name'],
        notification: json['notification'],
        id: json['id'],
        isSupporter: json['is_supporter'],
        notificationId: json['notification_id']);
  }
}
