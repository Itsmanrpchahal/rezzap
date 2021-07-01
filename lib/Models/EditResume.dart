class EditResume {
  final String name;
  final String phone;
  final String email;
  final String color;
  final String profile;
  final String categoryList;
  final String activityList;
  final String supporterList;
  final String interestList;
  final String supporterIds;

  EditResume(
      {this.name,
      this.phone,
      this.email,
      this.color,
      this.profile,
      this.categoryList,
      this.activityList,
      this.supporterList,
      this.interestList,
      this.supporterIds});

  factory EditResume.fromJson(Map<String, dynamic> json) {
    return EditResume(
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        color: json['color'],
        profile: json['profile'],
        categoryList: json['category_list'],
        activityList: json['activity_list'],
        supporterList: json['supporter_list'],
        interestList: json['interest_list'],
        supporterIds: json['supporter_ids']);
  }
}
