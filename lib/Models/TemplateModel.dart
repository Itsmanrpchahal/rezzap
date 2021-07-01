class Templates {
  final String resumeName;
  final String resumePhone;
  final String resumeEmail;
  final String resumeProfile;

  List<CategoryList> categoryList = [];
  List<IntersetList> interestList = [];
  List<SupporterList> supporterList = [];

  Templates(
      {this.resumeName,
      this.resumePhone,
      this.resumeEmail,
      this.resumeProfile,
      this.categoryList,
      this.interestList,
      this.supporterList});

  factory Templates.fromJson(Map<String, dynamic> json) {
    return Templates(
      resumeName: json['resume_name'],
      resumePhone: json['resume_phone'],
      resumeEmail: json['resume_email'],
      resumeProfile: json['resume_profile'],
      categoryList: (json['category_list'] as List).map((i) {
        return CategoryList.fromJson(i);
      }).toList(),
      interestList: (json['interest_list'] as List).map((i) {
        return IntersetList.fromJson(i);
      }).toList(),
      supporterList: (json['supporter_list'] as List).map((i) {
        return SupporterList.fromJson(i);
      }).toList(),
    );
  }
}

class SupporterList {
  final String name;

  SupporterList({this.name});

  factory SupporterList.fromJson(Map<String, dynamic> json) {
    return SupporterList(
      name: json['name'],
    );
  }
}

class IntersetList {
  final String name;

  IntersetList({this.name});

  factory IntersetList.fromJson(Map<String, dynamic> json) {
    return IntersetList(
      name: json['name'],
    );
  }
}

class CategoryList {
  final String name;
  List<AcitivityList> activityList = [];

  CategoryList({this.name, this.activityList});

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      name: json['name'],
      activityList: (json['activity_list'] as List).map((i) {
        return AcitivityList.fromJson(i);
      }).toList(),
    );
  }
}

class AcitivityList {
  final String title;
  final String mediaType;
  final String content;

  AcitivityList({this.title, this.mediaType, this.content});

  factory AcitivityList.fromJson(Map<String, dynamic> json) {
    return AcitivityList(
      title: json['title'],
      mediaType: json['media_type'],
      content: json['content'],
    );
  }
}
