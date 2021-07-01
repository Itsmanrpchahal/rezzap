class College {
  final String collegeName;
  final int id;
  final String schoolType;
  final String state;
  final String acceptanceRate;
  final String avgGPA;
  final String satMath;
  final String satCritical;
  final String actComposite;
  final String status;

  College(
      {this.collegeName,
      this.id,
      this.schoolType,
      this.state,
      this.acceptanceRate,
      this.avgGPA,
      this.satMath,
      this.satCritical,
      this.actComposite,
      this.status});

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
        collegeName: json['college_name'],
        id: json['id'],
        schoolType: json['school_type'],
        state: json['state'],
        acceptanceRate: json['acceptance_rate'],
        avgGPA: json['avg_gpa'],
        satMath: json['sat_math'],
        satCritical: json['sat_critical'],
        actComposite: json['act_composite'],
        status: json['status']);
  }
}
