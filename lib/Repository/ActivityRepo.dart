import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/ActivityModel.dart';
import 'package:rezzap/Models/CommentModel.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final getActivityUrl = "activity/show";
  static final addActivityUrl = "activity/store";
  static final updateActivityUrl = "activity/update";
  static final deleteActivityUrl = "activity/destroy?id=";
  static final addCommentUrl = "activity/add-comment";
  static final deleteCommentUrl = "activity/delete-comment?id=";
  static final showCommentUrl = "activity/show-comment?id=";
  static final supportActivityUrl = "activity/support-unsupport";
  static final filterActivityUrl = "activity/category-activity?category_id=";
  static final supporterFilterActivityUrl =
      "activity/supporter-category-activity?";
  static final supporterAllActivityUrl = "activity/show-supporters";

  //GET ACTIVITY
  Future<List<Activity>> getActivityData() async {
    final response = await _helper.get(getActivityUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Activity.fromJson(d)).toList();
  }

  //GET ALL SUPPORTERS ACTIVITY
  Future<List<Activity>> getAllActivityData() async {
    final response = await _helper.get(supporterAllActivityUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Activity.fromJson(d)).toList();
  }

  //GET FILTER ACTIVITY
  Future<List<Activity>> getFilterActivityData(String id) async {
    final response = await _helper.get(filterActivityUrl + id);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Activity.fromJson(d)).toList();
  }

  //GET SUPPORTER FILTER ACTIVITY
  Future<List<Activity>> getSupporterFilterActivityData(
      String userId, String categoryId) async {
    final response = await _helper.get(supporterFilterActivityUrl +
        "supporter_id=$userId&category_id=$categoryId");
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Activity.fromJson(d)).toList();
  }

  //ADD ACTIVITY TEXT
  Future<bool> addActivityText(String title, String category, String content,
      String mediaType, String eventDate) async {
    final response = await _helper.post(addActivityUrl, {
      "title": title,
      "category": category,
      "content": content,
      "media_type": mediaType,
      "event_date": eventDate
    });
    print(response);
    return true;
  }

  //SUPPORT SCTIVITY
  Future<bool> supportActivity(String id, String supportType) async {
    final response = await _helper.post(supportActivityUrl, {
      "id": id,
      "support_type": supportType,
    });
    print(response);
    return true;
  }

  //ADD COMMENT
  Future<bool> addComment(String id, String comment) async {
    final response = await _helper.post(addCommentUrl, {
      "activity_id": id,
      "comment": comment,
    });
    print(response);
    return true;
  }

  //GET COMMENT
  Future<List<Comment>> getComment(String activityId) async {
    final response = await _helper.get(showCommentUrl + activityId);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Comment.fromJson(d)).toList();
  }

  //DELETE COMMENT
  Future<bool> deleteComment(String id) async {
    final response = await _helper.delete(deleteCommentUrl + id);
    print(response);
    return true;
  }

  //UPDATE ACTIVITY Text
  Future<bool> updateActivityText(String id, String title, String category,
      String content, String mediaType, String eventDate) async {
    final response = await _helper.post(addActivityUrl, {
      "id": id,
      "title": title,
      "category": category,
      "content": content,
      "media_type": mediaType,
      "event_date": eventDate
    });
    print(response);
    return true;
  }

  //ADD ACTIVITY Files
  Future<bool> addActivity(String title, String category, PickedFile content,
      String mediaType, String eventDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.baseUrl + addActivityUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['category'] = category;
    request.fields['media_type'] = mediaType.toString();
    request.fields['event_date'] = eventDate;
    request.files
        .add(await http.MultipartFile.fromPath('content', content.path));
    print(
        "Multuparts Api with url ${Constant.baseUrl + addActivityUrl} token $token and params: $title + $eventDate +$category +$mediaType also image ${content.path} ");
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return true;
  }

  //EDIT ACTIVITY
  Future<bool> updateActivity(String id, String title, String category,
      PickedFile content, int mediaType, String eventDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.baseUrl + updateActivityUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id'] = id;
    request.fields['title'] = title;
    request.fields['category'] = category;
    request.fields['media_type'] = mediaType.toString();
    request.fields['event_date'] = eventDate;
    request.files
        .add(await http.MultipartFile.fromPath('content', content.path));
    print(
        "Multuparts Api with url ${Constant.baseUrl + updateActivityUrl} token $token and params: $id + $title + $eventDate +$category +$mediaType also image ${content.path} ");
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return true;
  }

  //DELETE ACTIVITY
  Future<bool> deleteActivity(String id) async {
    final response = await _helper.delete(deleteActivityUrl + id);
    print(response);
    return true;
  }
}
