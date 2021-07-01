import 'dart:io';
import 'package:flutter/services.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/InterestModel.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InterestRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final addInterestUrl = "interests/store";
  static final getInterestUrl = "interests/show";
  static final deleteInterestUrl = "interests/destroy?id=";
  static final editInterestUrl = "interests/update";

//ADD INTEREST
  Future<bool> addInterest(String title, String url, File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.baseUrl + addInterestUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['url'] = url;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    print(
        "Multuparts Api with url ${Constant.baseUrl + addInterestUrl} token $token and params: $title + $url also image ${image.path} ");
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return true;
  }

  Future<bool> addNoImageInterest(String title, String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.baseUrl + addInterestUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['url'] = url;
    request.files.add(http.MultipartFile.fromBytes(
        'image',
        (await rootBundle.load('assets/images/empty.jpeg'))
            .buffer
            .asUint8List(),
        filename: 'photo.jpg'));
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return true;
  }

  //GET INTEREST
  Future<List<Interest>> getInterestData() async {
    final response = await _helper.get(getInterestUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => Interest.fromJson(d)).toList();
  }

  //DELETE INTEREST
  Future<bool> deleteInterest(String id) async {
    final response = await _helper.delete(deleteInterestUrl + id);
    print(response);
    return true;
  }

  //EDIT INTEREST
  Future<bool> editInterest(
      String id, String title, String url, File image, String isImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.baseUrl + editInterestUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id'] = id;
    request.fields['title'] = title;
    request.fields['url'] = url;
    request.fields['is_image'] = isImage;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    print(
        "Multuparts Api with url ${Constant.baseUrl + editInterestUrl} token $token and params: $title + $url also image ${image.path} ");
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return true;
  }

  //EDIT No Image INTEREST
  Future<bool> editNoImageInterest(
      String id, String title, String url, String isImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse(Constant.baseUrl + editInterestUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id'] = id;
    request.fields['title'] = title;
    request.fields['url'] = url;
    request.fields['is_image'] = isImage;
    request.files.add(http.MultipartFile.fromBytes(
        'image',
        (await rootBundle.load('assets/images/empty.jpeg'))
            .buffer
            .asUint8List()));
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return true;
  }
}
