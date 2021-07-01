import 'package:rezzap/Models/AllSpin.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';

class AllSpinRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final getAllSpinUrl = "spin/list";
  static final getMySpinUrl = "spin/my-list";
  static final getSearchSpinUrl = "spin/search-spin-list?keyword=";
  static final followUnfolowUrl = "spin/follow-unfollow";

// GET ALL SPIN
  Future<List<AllSpin>> getAllSpinData() async {
    final response = await _helper.get(getAllSpinUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => AllSpin.fromJson(d)).toList();
  }

  // GET ALL SPIN
  Future<List<AllSpin>> getMySpinData() async {
    final response = await _helper.get(getMySpinUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => AllSpin.fromJson(d)).toList();
  }

  // SEARCH ALL SPIN
  Future<List<AllSpin>> getSearchSpinData(String keyword) async {
    final response = await _helper.get(getSearchSpinUrl + keyword);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => AllSpin.fromJson(d)).toList();
  }

  //STATUS FOLLOW OR UNFOLLOW
  Future<bool> userFollowUnfollow(String id, String statusType) async {
    final response = await _helper.post(
        followUnfolowUrl, {"supporter_id": id, "status_type": statusType});
    print(response);
    return true;
  }
}
