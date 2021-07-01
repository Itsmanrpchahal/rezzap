class UserDocs {
  final String personal;
  final String professional;
  final String academic;
  final String awards;
  final String other;

  UserDocs({
    this.personal,
    this.professional,
    this.academic,
    this.awards,
    this.other,
  });

  factory UserDocs.fromJson(Map<String, dynamic> json) {
    return UserDocs(
      personal: json['personal'],
      professional: json['professional'],
      academic: json['academic'],
      awards: json['awards'],
      other: json['other'],
    );
  }
}
