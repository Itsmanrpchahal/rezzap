class Supporter {
  final String userId;
  final String id;
  final String firstName;
  final String lastName;
  final String name;
  final String profilePhoto;
  final String rezzapId;

  final int isFollow;
  final String visibility;
  final int isRequested;

  Supporter(
      {this.userId,
      this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.profilePhoto,
      this.rezzapId,
      this.isFollow,
      this.visibility,
      this.isRequested});

  factory Supporter.fromJson(Map<String, dynamic> json) {
    return Supporter(
        userId: json['user_id'],
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        name: json['name'],
        profilePhoto: json['profile_photo'],
        rezzapId: json['social_media'],
        isFollow: json['is_follow'],
        isRequested: json['is_requested'],
        visibility: json['visibility']);
  }
}
