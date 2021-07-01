import 'package:rezzap/Models/ActivityModel.dart';
import 'package:rezzap/Models/CategoryModel.dart';
import 'package:rezzap/Models/InterestModel.dart';
import 'package:rezzap/Models/SupporterModel.dart';
import 'package:rezzap/Models/UserModel.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';

class SupporterRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final inviteSupporterUrl = "supporter/find?keyword=";
  static final sendInviteUrl = "supporter/send-invite";
  static final getSupportersUrl = "supporter/list";
  static final deleteSupportersUrl = "supporter/remove?to_user=";

  static final supporterProfileUrl = "supporter/profile?supporter_id=";
  static final supporterSupporterListUrl =
      "supporter/supporter-list?supporter_id=";
  static final supporterIterestUrl = "supporter/interests-list?supporter_id=";
  static final supporterGraphUrl =
      "supporter/category-graph-list?supporter_id=";
  static final supporterCategoryUrl = "supporter/category-list?supporter_id=";
  static final supporterActivityUrl = "supporter/activity-list?supporter_id=";

  //GET SUPPORTER BY SEARCH
  Future<List<Supporter>> inviteSupporter(String keyword) async {
    final response = await _helper.get(inviteSupporterUrl + keyword);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Supporter.fromJson(d)).toList();
  }

  //SEND SUPPORTER INVITE
  Future<bool> sendSupporterInvite(String toUser) async {
    final response = await _helper.post(sendInviteUrl, {"to_user": toUser});
    print(response);
    return true;
  }

  //GET ALL LIST
  Future<List<Supporter>> getSupporters() async {
    final response = await _helper.get(getSupportersUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Supporter.fromJson(d)).toList();
  }

  //DELETE SUPPORTER
  Future<bool> deleteSupporter(String id) async {
    final response = await _helper.delete(deleteSupportersUrl + id);
    print(response);
    return true;
  }

  //GET SUPPORTER DATA
  Future<User> getSupporterData(String id) async {
    final response = await _helper.get(supporterProfileUrl + id);
    return User.fromJson(response["data"]);
  }

  //GET SUPPORTER INTEREST
  Future<List<Interest>> getSupporterInterestData(String id) async {
    final response = await _helper.get(supporterIterestUrl + id);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Interest.fromJson(d)).toList();
  }

  //GET SUPPORTER SUPPORTERLIST
  Future<List<Supporter>> getSupportersSupportersList(String id) async {
    final response = await _helper.get(supporterSupporterListUrl + id);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Supporter.fromJson(d)).toList();
  }

  //GET SUPPORTER CATEGORY
  Future<List<Category>> getSupporterCategoryData(String id) async {
    final response = await _helper.get(supporterCategoryUrl + id);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Category.fromJson(d)).toList();
  }

  //GET SUPPORTER GRAPH
  Future<List<CategorySpin>> getSupporterCategoryGraph(String id) async {
    final response = await _helper.get(supporterGraphUrl + id);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => CategorySpin.fromJson(d)).toList();
  }

  //GET SUPPORTER ACTIVITY
  Future<List<Activity>> getSupporterActivityData(String id) async {
    final response = await _helper.get(supporterActivityUrl + id);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Activity.fromJson(d)).toList();
  }
}
