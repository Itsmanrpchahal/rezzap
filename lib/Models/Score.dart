class CollegeScore {
  final String avgGPA;
  final String satMath;
  final String satCritical;
  final String actComposite;
  final String torFile;
  final String satFile;
  final String actFile;
  final String subscription;

  CollegeScore(
      {this.avgGPA,
      this.satMath,
      this.satCritical,
      this.actComposite,
      this.torFile,
      this.satFile,
      this.actFile,
      this.subscription});

  factory CollegeScore.fromJson(Map<String, dynamic> json) {
    return CollegeScore(
      avgGPA: json['avg_gpa'],
      satMath: json['sat_math'],
      satCritical: json['sat_critical'],
      actComposite: json['act_composite'],
      torFile: json['tor_file'],
      satFile: json['sat_file'],
      actFile: json['act_file'],
      subscription: json['subscription'],
    );
  }
}

class SateType {
  final String state;

  SateType({
    this.state,
  });

  factory SateType.fromJson(Map<String, dynamic> json) {
    return SateType(
      state: json['state'],
    );
  }
}

class SchoolType {
  final String schoolType;

  SchoolType({
    this.schoolType,
  });

  factory SchoolType.fromJson(Map<String, dynamic> json) {
    return SchoolType(
      schoolType: json['school_type'],
    );
  }
}
