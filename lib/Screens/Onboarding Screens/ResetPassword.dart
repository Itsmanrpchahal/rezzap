import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Repository/UserRepo.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/SignIn.dart';

// ignore: must_be_immutable
class ResetPassword extends StatefulWidget {
  String email;
  ResetPassword(this.email);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController otpController;
  TextEditingController passwordController;
  TextEditingController conformPassController;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  void initState() {
    super.initState();
    otpController = TextEditingController();
    passwordController = TextEditingController();
    conformPassController = TextEditingController();
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      if (passwordController.text != conformPassController.text) {
        EasyLoading.showError("Password did not match");
      } else {
        resetPasswoed(
            widget.email, otpController.text, passwordController.text);
      }
    }
  }

  resetPasswoed(String email, String otp, String password) {
    EasyLoading.show();
    UserRepo().resetPassword(email, otp, password).then((bool isverify) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((Exception error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/signInBg.jpg"),
        fit: BoxFit.cover,
      )),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 100),
                child: Text(
                  "An Otp has been shared with you in your registered email address,",
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 40, top: 50),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "OTP",
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                    controller: otpController,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'OTP shared in email',
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black))),
                    textInputAction: TextInputAction.next,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter first name.' : null,
                  )),
              Container(
                  margin: EdgeInsets.only(left: 40, top: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                    controller: passwordController,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText1 = !_obscureText1;
                              });
                            },
                            icon: Icon(
                              _obscureText1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            )),
                        hintText: 'Password',
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black))),
                    validator: (val) =>
                        val.length < 6 ? 'Password too short.' : null,
                    obscureText: _obscureText1,
                  )),
              Container(
                  margin: EdgeInsets.only(left: 40, top: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Confirm Password",
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                    controller: conformPassController,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText2 = !_obscureText2;
                              });
                            },
                            icon: Icon(
                              _obscureText2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            )),
                        hintText: 'Password',
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black))),
                    validator: (val) =>
                        val.length < 6 ? 'Password too short.' : null,
                    obscureText: _obscureText2,
                  )),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RawMaterialButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      fillColor: Colors.black,
                      child: new Container(
                        height: 50.0,
                        width: 200,
                        child: new Center(
                          child: Text(
                            "Submit",
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      onPressed: () {
                        validateAndSave();
                      })),
            ],
          )),
    );
  }
}
