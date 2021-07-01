import 'dart:io';
import 'package:rezzap/Common+Store/CommonPrefrence.dart';
import 'package:rezzap/Models/UserModel.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';

class UserRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final signInUrl = "login";
  static final signUpUrl = "register";
  static final confirmEmailUrl = "email-confirmation";
  static final forgotPasswordUrl = "password/reset";
  static final resetPasswordUrl = "password/reset-password";
  static final getUserUrl = "profile-me";
  static final updateUserUrl = "update-profile";
  static final updatePicUrl = "update-profile-pic";
  static final makePaymentUrl = "payment/add";

//SIGN IN USER
  Future<User> login(String email, String password) async {
    final response = await _helper
        .postAuth(signInUrl, {"email": email, "password": password});
    SharedPrefrence().setToken(response["data"]["access_token"].toString());
    SharedPrefrence()
        .setEmailVerified(response["email_confirmed"] == "0" ? false : true);
    return User.fromJson(response);
  }

//SIGN UP USER
  Future<User> signUp(
      String email,
      String password,
      String rezzapId,
      String firstName,
      String lastName,
      String mobile,
      String accountType,
      String address,
      String city,
      String state,
      String zip,
      String dob,
      String street,
      String gender) async {
    final response = await _helper.postAuth(signUpUrl, {
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "mobile": mobile,
      "account_type": accountType,
      "address": address,
      "city": city,
      "state": state,
      "zip": zip,
      "dob": dob,
      "social_media": rezzapId,
      "gender": gender,
      "street": street
    });

    SharedPrefrence().setToken(response["data"]["access_token"].toString());
    SharedPrefrence()
        .setEmailVerified(response["email_confirmed"] == 0 ? false : true);

    return User.fromJson(response);
  }

//CONFIRM EMAIL
  Future<bool> confirmEmail(String otp) async {
    final response = await _helper.postAuth(confirmEmailUrl, {"otp": otp});
    print(response);
    return true;
  }

//FORGOT PASSWORD
  Future<User> forgotPassword(String email) async {
    final response =
        await _helper.postAuth(forgotPasswordUrl, {"email": email});
    print(response);
    return User.fromJson(response);
  }

//RRESET PASSWORD
  Future<bool> resetPassword(String email, String otp, String password) async {
    final response = await _helper.postAuth(
        resetPasswordUrl, {"email": email, "otp": otp, "password": password});
    print(response);
    return true;
  }

  //GET USER DATA
  Future<User> getUserData() async {
    final response = await _helper.get(getUserUrl);
    var userId = response["data"]["id"].toString();
    var profilPic = response["data"]["profile_photo"].toString();
    var subscription = response["data"]["subscription"].toString();
    SharedPrefrence().setSubscription(subscription);
    SharedPrefrence().setUserId(userId);
    SharedPrefrence().setProfilePhoto(profilPic);
    return User.fromJson(response["data"]);
  }

  //UPDATE USER DATA
  Future<User> updateUser(
      String firstName,
      String lastName,
      String mobile,
      String address,
      String state,
      String dob,
      String street,
      String gender,
      String visibility,
      String highSchool,
      String college,
      String designation,
      String degree,
      String accountType) async {
    final response = await _helper.put(updateUserUrl, {
      "first_name": firstName,
      "last_name": lastName,
      "mobile": mobile,
      "address": address,
      "state": state,
      "dob": dob,
      "gender": gender,
      "street": street,
      "visibility": visibility,
      "highschool": highSchool,
      "college": college,
      "designation": designation,
      "degree": degree,
      "account_type": accountType
    });
    return User.fromJson(response);
  }

  //UPDATE PHOTO
  Future<bool> uploadProfilePic(File file) async {
    final response = await _helper.upload(file, updatePicUrl);
    print(response);
    return true;
  }

  //PAYMENT
  Future<bool> sendPaymentNonce(String nonce) async {
    final response = await _helper.post(makePaymentUrl, {"nonce_token": nonce});
    print(response);
    return true;
  }
}
