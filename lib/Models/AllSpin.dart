class AllSpin {
  final String name;
  final int isFollow;
  final String userId;
  final String visibility;
  final int isRequested;
  List<GraphList> graphList = [];

  AllSpin(
      {this.name,
      this.isFollow,
      this.graphList,
      this.userId,
      this.visibility,
      this.isRequested});

  factory AllSpin.fromJson(Map<String, dynamic> json) {
    return AllSpin(
      name: json['name'],
      userId: json['user_id'],
      visibility: json['visibility'],
      graphList: (json['graph_list'] as List).map((i) {
        return GraphList.fromJson(i);
      }).toList(),
      isRequested: json['is_requested'],
      isFollow: json['is_follow'],
    );
  }
}

class GraphList {
  final String categoryName;
  final int categoryId;
  final String color;
  final int activityCount;
  final String percentage;

  GraphList(
      {this.categoryName,
      this.categoryId,
      this.color,
      this.activityCount,
      this.percentage});

  factory GraphList.fromJson(Map<String, dynamic> json) {
    return GraphList(
        categoryId: json['category_id'],
        activityCount: json['activity_count'],
        categoryName: json['category_name'],
        color: json['color'],
        percentage: json['percentage']);
  }
}
