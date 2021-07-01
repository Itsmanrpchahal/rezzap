import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:rezzap/Common+Store/Contants.dart';
import 'dart:convert';
import 'package:rezzap/Network%20Calls/ApiException.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class ApiBaseHelper {
  final String _baseUrl = "https://www.rezzap.com/app/api/";

  // GET API
  Future<dynamic> get(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    print('Api Get, url ${_baseUrl + url}: ');
    var responseJson;
    try {
      final response = await http
          .get(_baseUrl + url, headers: {"Authorization": "Bearer $token"});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

// POST API
  Future<dynamic> post(String url, dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';

    print('Api Post, url ${_baseUrl + url} with params: $body and $token');
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: body, headers: {"Authorization": "Bearer $token"});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // POST AUTH API
  Future<dynamic> postAuth(String url, dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';

    print('Api Post, url ${_baseUrl + url} with params: $body and $token');
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          body: body, headers: {"Authorization": "$token"});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

//PUT API
  Future<dynamic> put(String url, dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    print(
        'Api Put, url ${_baseUrl + url} : with param $body with token $token');
    var responseJson;
    try {
      final response = await http.put(_baseUrl + url,
          body: body, headers: {"Authorization": "Bearer $token"});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

//DELETE API
  Future<dynamic> delete(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    print('Api delete, url $url');
    var apiResponse;
    try {
      final response = await http
          .delete(_baseUrl + url, headers: {"Authorization": "Bearer $token"});

      apiResponse = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return apiResponse;
  }

//MULTIPARTS
  upload(File imageFile, String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KeyConstants.token) ?? '';
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl + url));
    request.files
        .add(await http.MultipartFile.fromPath('profile_pic', imageFile.path));
    request.headers.addAll({"Authorization": "Bearer $token"});
    var res = await request.send();
    return res.reasonPhrase;
  }
}

//RESPONSES WITH STATUS CODE
dynamic _returnResponse(http.Response response) {
  var responseJson = json.decode(response.body.toString());
  var message = responseJson["message"];
  print(responseJson);

  switch (response.statusCode) {
    case 200:
      EasyLoading.dismiss();
      return responseJson;
    case 201:
      print(responseJson);
      EasyLoading.dismiss();
      return responseJson;
    case 400:
      EasyLoading.showError(message);
      throw BadRequestException(response.body.toString());
    case 401:
      EasyLoading.showError(message);
      throw InvalidInputException(response.body.toString());
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 404:
      EasyLoading.showError("Error fetching details");
      throw UnauthorisedException(response.body.toString());
    case 500:
      EasyLoading.showError("Error fetching details");
      break;
    default:
      EasyLoading.dismiss();
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

// MAKE FILE FROM URL
Future<File> urlToFile(String imageUrl) async {
  var rng = new Random();
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
  http.Response response = await http.get(imageUrl);
  await file.writeAsBytes(response.bodyBytes);
  return file;
}
