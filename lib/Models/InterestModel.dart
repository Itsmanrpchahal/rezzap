class Interest {
  final String title;
  final String url;
  final String image;
  final int id;

  Interest({
    this.title,
    this.url,
    this.image,
    this.id,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      title: json['title'],
      url: json['url'],
      image: json['image'],
      id: json['id'],
    );
  }
}
