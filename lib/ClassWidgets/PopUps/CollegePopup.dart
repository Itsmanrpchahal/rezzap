import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Repository/CollegeRepo.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

class CollegePopUp extends StatefulWidget {
  @override
  _CollegePopUpState createState() => _CollegePopUpState();
}

class _CollegePopUpState extends State<CollegePopUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController collegeController;
  TextEditingController stateController;

  @override
  void initState() {
    super.initState();
    collegeController = TextEditingController();
    stateController = TextEditingController();
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      sendRequestCollege(collegeController.text, stateController.text);
    }
  }

  void sendRequestCollege(String collegeName, String state) {
    EasyLoading.show();
    CollegeRepo().sendCollegeRequest(collegeName, state).then((value) => {
          EasyLoading.showInfo(
              "Your request for $collegeName has been sent successfully"),
          Navigator.pop(context)
        });
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
                    height: 10,
                  ),
                  Center(
                      child: Text("Can't See Your College?",
                          style: GoogleFonts.lato(
                              fontSize: 18, fontWeight: FontWeight.w600))),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: TextFormField(
                        controller: collegeController,
                        decoration: new InputDecoration(
                          labelText: "College Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Enter College Name";
                          } else {
                            return null;
                          }
                        },
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: TextFormField(
                        controller: stateController,
                        decoration: new InputDecoration(
                          labelText: "State",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Enter State";
                          } else {
                            return null;
                          }
                        },
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  buttonMenu("Send Request", () {
                    validateAndSave();
                  }, context, AppColors.greenColor, 150),
                  SizedBox(
                    height: 15,
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
