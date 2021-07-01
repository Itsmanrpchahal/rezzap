import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/UserModel.dart';
import 'package:rezzap/Repository/UserRepo.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/ResetPassword.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController;
  UserRepo userRepository = UserRepo();

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      forgotPassword(emailController.text);
    }
  }

  forgotPassword(String email) {
    EasyLoading.show();
    userRepository.forgotPassword(email).then((User user) {
      EasyLoading.dismiss();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResetPassword(emailController.text)),
      );
    // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((Exception error) => print(error));
  }

  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/signInBg.jpg"),
          fit: BoxFit.cover,
        )),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: Center(
                        child: Text(
                      "Please enter your registered email here",
                      style: GoogleFonts.lato(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ))),
                Container(
                  margin: EdgeInsets.only(top: 70, left: 40, right: 40),
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Email",
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 20),
                              child: TextFormField(
                                controller: emailController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => ValidConstants.isEmail(value)
                                    ? null
                                    : "Please enter vaild email",
                              ))),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 30),
                          child: RawMaterialButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              fillColor: Colors.black,
                              child: new Container(
                                height: 60.0,
                                width: 200,
                                child: new Center(
                                  child: Text(
                                    "Register",
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
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
