import 'package:rezzap/Models/CategoryModel.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';

class CategoryRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final getCategorytUrl = "category/show";
  static final addCategorytUrl = "category/store";
  static final deleteCategorytUrl = "category/destroy?id=";
  static final addAllCategorytUrl = "category/store-categories";
  static final editCategorytUrl = "category/update";
  static final showCategorytUrl = "category/show-categories";
  static final showCategoryGraphUrl = "category/show-graph";

  //GET DEFAULT CATEGORY
  Future<List<Category>> getCategoryData() async {
    final response = await _helper.get(getCategorytUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Category.fromJson(d)).toList();
  }

  //SHOW ALL CATEGORY
  Future<List<Category>> showCategoryData() async {
    final response = await _helper.get(showCategorytUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Category.fromJson(d)).toList();
  }

  //ADD CATEGORY
  Future<bool> addCategoryData(String title) async {
    final response = await _helper.post(addCategorytUrl, {"title": title});
    print(response);
    return true;
  }

  //DELETE CATEGORY
  Future<bool> deleteCategoryData(String id) async {
    final response = await _helper.delete(deleteCategorytUrl + id);
    print(response);
    return true;
  }

  //ADD ALL CATEGORY
  Future<bool> storesCategoryData(String ids) async {
    final response =
        await _helper.post(addAllCategorytUrl, {"category_ids": ids});
    print(response);
    return true;
  }

  //EDIT CATEGORY
  Future<bool> editCategoryData(String title, String id) async {
    final response =
        await _helper.put(editCategorytUrl, {"title": title, "id": id});
    print(response);
    return true;
  }

  //GET GRAPH CATEGORY
  Future<List<CategorySpin>> getCategoryGraph() async {
    final response = await _helper.get(showCategoryGraphUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => CategorySpin.fromJson(d)).toList();
  }
}
