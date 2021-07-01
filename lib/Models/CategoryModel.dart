class Category {
  final String categoryIds;
  final int id;
  final String color;
  final String title;
  final int isDefault;
  final String createdBy;

  Category(
      {this.categoryIds,
      this.id,
      this.color,
      this.title,
      this.isDefault,
      this.createdBy});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        categoryIds: json['category_ids'],
        id: json['id'],
        color: json['color'],
        title: json['title'],
        isDefault: json['default'],
        createdBy: json['created_by']);
  }
}

// CATEGORY WITH GRAPH
class CategorySpin {
  final int categoryId;
  final String color;
  final String categoryName;
  final int activityCount;
  final String percentage;

  CategorySpin(
      {this.categoryId,
      this.color,
      this.categoryName,
      this.activityCount,
      this.percentage});

  factory CategorySpin.fromJson(Map<String, dynamic> json) {
    return CategorySpin(
        categoryId: json['category_id'],
        color: json['color'],
        categoryName: json['category_name'],
        activityCount: json['activity_count'],
        percentage: json['percentage']);
  }
}

class ResumeCat {
  final String catName;
  final int catId;

  ResumeCat({
    this.catName,
    this.catId,
  });

  factory ResumeCat.fromJson(Map<String, dynamic> json) {
    return ResumeCat(
      catName: json['cat_name'],
      catId: json['cat_id'],
    );
  }
}
