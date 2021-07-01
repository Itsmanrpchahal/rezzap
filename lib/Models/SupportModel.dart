class Support {
  Support({
    this.data,
  });

  Map<String, List<Datum>> data;

  factory Support.fromJson(Map<String, dynamic> json) => Support(
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<Datum>>(
                k, List<Datum>.from(v.map((x) => Datum.fromJson(x))))),
      );
}

class Datum {
  Datum({this.imgUrl, this.person, this.message, this.userId});

  String imgUrl;
  String person;
  String message;
  String userId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      imgUrl: json["img_url"],
      person: json["person"],
      message: json["message"],
      userId: json["user_id"]);
}
