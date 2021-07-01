import 'dart:io';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/Colleges.dart';
import 'package:rezzap/Models/Score.dart';
import 'package:rezzap/Models/UserDoc.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CollegeRepo {
  ApiBaseHelper _helper = ApiBaseHelper();

  static final getAllCollegeUrl = "college/list";
  static final postTestScoreUrl = "college/add-test-score";
  static final getFilesUrl = "user/get-user-docs";
  static final addDreamCollegesUrl = "college/add-dream-college";
  static final getDreamCollegeUrl = "college/dream-colleges";
  static final getSchoolUrl = "college/school-type-list";
  static final getSateUrl = "college/state-list";
  static final deleteDreamCollegesUrl =
      "college/remove-dream-college?college_id=";
  static final searchAllColleges = "college/search-college?keyword=";
  static final searchByStateSchoolColleges = "college/search-state-school?";
  static final sendCollegeRequestUrl = "college/send-college-request";
  static final addFileUrl = "user/add-user-docs";
  static final deleteTestFileUrl = "user/remove-user-docs?delete_type=";

  //GET ALL COLLEGES
  Future<List<College>> getCollegesData() async {
    final response = await _helper.get(getAllCollegeUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => College.fromJson(d)).toList();
  }

  //GET ALL STATES
  Future<List<SateType>> getSateData() async {
    final response = await _helper.get(getSateUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => SateType.fromJson(d)).toList();
  }

  //GET ALL SCHOOLS
  Future<List<SchoolType>> getSchoolData() async {
    final response = await _helper.get(getSchoolUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => SchoolType.fromJson(d)).toList();
  }

  //SEARCH ALL COLLEGES
  Future<List<College>> searchAllCollegesData(String keyword) async {
    final response = await _helper.get(searchAllColleges + keyword);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => College.fromJson(d)).toList();
  }

  //SEARCH ALL COLLEGES
  Future<List<College>> searchByStateSchoolData(
      String state, String schoolType) async {
    final response = await _helper.get(
        searchByStateSchoolColleges + "state=$state&school_type=$schoolType");
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => College.fromJson(d)).toList();
  }

  //POST SCORE
  Future<bool> postTestScore(String avgGpa, String sathMath,
      String sathCritical, String actComposite) async {
    final response = await _helper.post(postTestScoreUrl, {
      "avg_gpa": avgGpa,
      "sat_math": sathMath,
      "sat_critical": sathCritical,
      "act_composite": actComposite
    });
    print(response);
    return true;
  }

  //POST COLLEGE REQUEST
  Future<bool> sendCollegeRequest(String collegeName, String state) async {
    final response = await _helper.post(sendCollegeRequestUrl, {
      "college_name": collegeName,
      "state": state,
    });
    print(response);
    return true;
  }

  //DELETE DREAM COLLEGES
  Future<bool> deleteDreamColleges(String id) async {
    final response = await _helper.delete(deleteDreamCollegesUrl + id);
    print(response);
    return true;
  }

  //ADD DREAM COLLEGES
  Future<bool> addDreamColleges(String collegeIds) async {
    final response =
        await _helper.post(addDreamCollegesUrl, {"college_ids": collegeIds});
    print(response);
    return true;
  }

  //GET DREAM COLLEGES
  Future<List<College>> getDreamCollegesData() async {
    final response = await _helper.get(getDreamCollegeUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => College.fromJson(d)).toList();
  }

  //GET ALL FILE DATA
  Future<UserDocs> getAllFiles() async {
    final response = await _helper.get(getFilesUrl);
    return UserDocs.fromJson(response["data"]);
  }

  //ADD FILES FILES
  Future<bool> addFiles(String uplaodType, File fileName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    var request =
        http.MultipartRequest('POST', Uri.parse(Constant.baseUrl + addFileUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['upload_type'] = uplaodType;
    request.files
        .add(await http.MultipartFile.fromPath('file_name', fileName.path));
    print(
        "Multuparts Api with url ${Constant.baseUrl + addFileUrl} token $token and data ${fileName.path} ");
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return true;
  }

  //DELETE TEST FILES
  Future<bool> deleteTestFiles(String id) async {
    final response = await _helper.delete(deleteTestFileUrl + id);
    print(response);
    return true;
  }
}
