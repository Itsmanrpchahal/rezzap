import 'package:rezzap/Models/SupportModel.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';

class SupportRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final supportedActivityUrl = "activity/get-support-logs";
  static final facebookActivityUrl = "register";

  // GET ALL SUPPORTED ACTIVITY
  Future<Support> getSupportActivityData() async {
    final response = await _helper.get(supportedActivityUrl);
    return Support.fromJson(response);
  }

  // GET ALL FACEBBOK ACTIVITY
  Future<List<Support>> getFacebbokActivityData() async {
    final response = await _helper.get(supportedActivityUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Support.fromJson(d)).toList();
  }
}
