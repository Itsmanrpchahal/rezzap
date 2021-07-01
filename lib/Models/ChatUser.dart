class ChatUser {
  final String name;
  final String id;
  final String profilePhoto;
  final String message;
  final String seen;

  ChatUser({this.name, this.id, this.profilePhoto, this.message, this.seen});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      name: json['name'],
      id: json['id'],
      profilePhoto: json['profile_photo'],
      message: json['message'],
      seen: json['seen'],
    );
  }
}
