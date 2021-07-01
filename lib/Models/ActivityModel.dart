class Activity {
  final String title;
  final String category;
  final String eventDate;
  final String mediaType;
  final String content;
  final int id;
  final String createdAt;
  final int supportCount;
  final int commentCount;
  final int isSupport;
  final String userId;

  final String firstName;
  final String lastName;
  final String profilepic;

  Activity(
      {this.title,
      this.category,
      this.eventDate,
      this.mediaType,
      this.content,
      this.id,
      this.isSupport,
      this.supportCount,
      this.commentCount,
      this.userId,
      this.createdAt,
      this.firstName,
      this.lastName,
      this.profilepic});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
        title: json['title'],
        category: json['category'],
        eventDate: json['event_date'],
        mediaType: json['media_type'],
        content: json['content'],
        createdAt: json['created_at'],
        isSupport: json['is_support'],
        commentCount: json['comment_count'],
        supportCount: json['support_count'],
        userId: json['user_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        profilepic: json['img_url'],
        id: json['id']);
  }
}
