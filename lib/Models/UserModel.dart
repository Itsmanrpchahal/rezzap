class User {
  final String email;
  final String password;
  final String mobile;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String street;
  final String state;
  final String zip;
  final String gender;
  final String accountType;
  final String rezzapId;
  final String dob;
  final String highschool;
  final String college;
  final String degree;
  final String designation;
  final String visibility;
  final String location;
  final String profilePhoto;
  final int isFollow;
  final String subscription;

  User(
      {this.email,
      this.password,
      this.mobile,
      this.firstName,
      this.lastName,
      this.address,
      this.city,
      this.street,
      this.state,
      this.zip,
      this.gender,
      this.accountType,
      this.rezzapId,
      this.dob,
      this.highschool,
      this.college,
      this.degree,
      this.designation,
      this.visibility,
      this.location,
      this.profilePhoto,
      this.isFollow,
      this.subscription});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        password: json['password'],
        mobile: json['mobile'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        address: json['address'],
        city: json['city'],
        street: json['street'],
        state: json['state'],
        zip: json['zip'],
        gender: json['gender'],
        accountType: json['account_type'],
        rezzapId: json['social_media'],
        dob: json['dob'],
        highschool: json['highschool'],
        college: json['college'],
        degree: json['degree'],
        designation: json['designation'],
        profilePhoto: json['profile_photo'],
        visibility: json['visibility'],
        isFollow: json['is_follow'],
        location: json['location'],
        subscription: json['subscription']);
  }
}
