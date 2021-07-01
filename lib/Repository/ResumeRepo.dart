import 'package:rezzap/Models/CategoryModel.dart';
import 'package:rezzap/Models/EditResume.dart';
import 'package:rezzap/Models/ResumeModel.dart';
import 'package:rezzap/Models/TemplateModel.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';

class ResumeRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final addResumeUrl = "resume/add";
  static final updateResumeUrl = "resume/update-resume";
  static final addTempResumeUrl = "resume/add-continue";
  static final getResumeUrl = "resume/my-resumes";
  static final deleteResumeUrl = "resume/delete?id=";
  static final resumeCategoryUrl = "resume/category-list";
  static final getResumeDetailUrl = "resume/resume-details?resume_id=";
  static final getResumeEditUrl = "resume/single-resume?resume_id=";

  //ADD RESUME
  Future<Addresume> addResume(
      String name,
      String email,
      String phone,
      String profile,
      String categoryIds,
      String activityIds,
      String supportersIds,
      String interestsIds) async {
    final response = await _helper.post(addResumeUrl, {
      "name": name,
      "email": email,
      "phone": phone,
      "profile": profile,
      "category_names": categoryIds,
      "activity_names": activityIds,
      "supporters_ids": supportersIds,
      "interest_names": interestsIds
    });
    return Addresume.fromJson(response["data"]);
  }

  //UPDATE RESUME
  Future<bool> updateResume(
      String resumeId,
      String name,
      String email,
      String phone,
      String profile,
      String categoryIds,
      String activityIds,
      String supportersIds,
      String interestsIds) async {
    final response = await _helper.put(updateResumeUrl, {
      "id": resumeId,
      "name": name,
      "email": email,
      "phone": phone,
      "profile": profile,
      "category_names": categoryIds,
      "activity_names": activityIds,
      "supporters_ids": supportersIds,
      "interest_names": interestsIds
    });
    print(response);
    return true;
  }

  //PUT TEMPLATE RESUME
  Future<bool> addTemplateResume(
    String resumeId,
    String templateId,
    String color,
  ) async {
    final response = await _helper.put(addTempResumeUrl, {
      "resume_id": resumeId,
      "template_id": templateId,
      "color": color,
      "is_grid": "0",
    });
    print(response);
    return true;
  }

  //GET ALL RESUME
  Future<List<Resume>> getUserResume() async {
    final response = await _helper.get(getResumeUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Resume.fromJson(d)).toList();
  }

  //GET EDIT RESUME
  Future<EditResume> getResumeEditData(String id) async {
    final response = await _helper.get(getResumeEditUrl + id);
    return EditResume.fromJson(response["data"]);
  }

  //GET ALL RESUME
  Future<Templates> getResumeData(String id) async {
    final response = await _helper.get(getResumeDetailUrl + id);
    return Templates.fromJson(response["data"]);
  }

  //GET ALL RESUME
  Future<List<ResumeCat>> getResumeCategory() async {
    final response = await _helper.get(resumeCategoryUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => ResumeCat.fromJson(d)).toList();
  }

  //DELETE RESUME
  Future<bool> deleteResume(String id) async {
    final response = await _helper.delete(deleteResumeUrl + id);
    print(response);
    return true;
  }
}
