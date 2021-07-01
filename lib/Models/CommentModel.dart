class Comment {
  final String comment;
  final int id;
  final String profilePhoto;
  final String name;
  final String createdAt;

  Comment(
      {this.comment, this.id, this.profilePhoto, this.name, this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        comment: json['comment'],
        id: json['id'],
        createdAt: json['created_at'],
        profilePhoto: json['profile_photo'],
        name: json['name']);
  }
}
