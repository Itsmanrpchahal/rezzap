class Resume {
  final String name;
  final String createdAt;
  final String updatededAt;
  final int id;
  final String phone;
  final String email;

  Resume(
      {this.name,
      this.createdAt,
      this.updatededAt,
      this.id,
      this.email,
      this.phone});

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'],
      createdAt: json['created_at'],
      updatededAt: json['updated_at'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}

class Addresume {
  final int resumeId;

  Addresume({
    this.resumeId,
  });

  factory Addresume.fromJson(Map<String, dynamic> json) {
    return Addresume(
      resumeId: json['resume_id'],
    );
  }
}
