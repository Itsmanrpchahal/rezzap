import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Repository/UserRepo.dart';
import 'package:rezzap/Screens/TabBarScreens/HomeTabBar.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

// ignore: must_be_immutable
class VerifyEmailPopUp extends StatefulWidget {
  bool isRegistering = true;
  VerifyEmailPopUp(this.isRegistering);
  @override
  _VerifyEmailPopUpState createState() => _VerifyEmailPopUpState();
}

class _VerifyEmailPopUpState extends State<VerifyEmailPopUp> {
  UserRepo userRepository = UserRepo();
  TextEditingController otpController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  verfiyEmail(String otp) {
    EasyLoading.show();
    userRepository.confirmEmail(otp).then((bool isverify) {
      EasyLoading.showInfo("Your email is verified!");
      widget.isRegistering
          ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeTabBar(0)),
            )
          : Navigator.of(context).pop();
    // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((Exception error) => print(error));
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      verfiyEmail(otpController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ValidConstants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 2), blurRadius: 2),
              ]),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                          child: Text(
                              "Please verify your email, a link has been sent to your regitered email address",
                              style: GoogleFonts.lato(fontSize: 18)))),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: TextFormField(
                        controller: otpController,
                        decoration: new InputDecoration(
                          labelText: "Verify Pin",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (val) {
                          if (val.length != 6) {
                            return "Please fill correct OTP";
                          } else {
                            return null;
                          }
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  buttonMenu("Verify", () {
                    validateAndSave();
                  }, context, Colors.black, 150),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
