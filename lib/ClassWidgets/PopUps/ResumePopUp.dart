import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/MultiSelectChip.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Repository/ActivityRepo.dart';
import 'package:rezzap/Repository/InterestRepo.dart';
import 'package:rezzap/Repository/ResumeRepo.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Screens/TabBarScreens/Resume%20Screens/DesignResume.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

// ignore: must_be_immutable
class ResumePopUp extends StatefulWidget {
  String resumeId = "";
  ResumePopUp(this.resumeId);
  @override
  _ResumePopUpState createState() => _ResumePopUpState();
}

class _ResumePopUpState extends State<ResumePopUp> {
  List<String> categoryList = [];
  List<String> interestList = [];
  List<String> activityList = [];
  List<String> supporterList = [];

  bool isCategory = false;
  bool isInterest = false;
  bool isActivity = false;
  bool isSupporter = false;
  String color = "";

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController phoneController;
  TextEditingController profileController;
  TextEditingController categoryController;
  TextEditingController activityController;
  TextEditingController supporterController;
  TextEditingController interestController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    profileController = TextEditingController();
    categoryController = TextEditingController();
    activityController = TextEditingController();
    supporterController = TextEditingController();
    interestController = TextEditingController();
    if (widget.resumeId != "0") {
      showEditResume(widget.resumeId);
    }
    showCategoryList();
    showInterestList();
    getActivitiesList();
    getSupporterList();
  }

  void showEditResume(String id) {
    EasyLoading.show();
    ResumeRepo().getResumeEditData(id).then((value) => {
          setState(() {
            nameController.text = value.name;
            emailController.text = value.email;
            phoneController.text = value.phone;
            profileController.text = value.profile;
            categoryController.text = value.categoryList;
            activityController.text = value.activityList;
            supporterController.text = value.supporterList;
            interestController.text = value.interestList;
            supporterController.text = value.supporterList;
            color = value.color;
          })
        });
  }

  void showCategoryList() {
    EasyLoading.show();
    ResumeRepo().getResumeCategory().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            for (var index = 0; index < value.length; index++) {
              categoryList.add(value[index].catName);
            }
          })
        });
  }

  void showInterestList() {
    InterestRepo().getInterestData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            for (var index = 0; index < value.length; index++) {
              interestList.add(value[index].title);
            }
          })
        });
  }

  void getSupporterList() {
    SupporterRepo().getSupporters().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            for (var index = 0; index < value.length; index++) {
              supporterList.add(value[index].rezzapId);
            }
          })
        });
  }

  void getActivitiesList() {
    EasyLoading.show();
    ActivityRepo().getActivityData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            for (var index = 0; index < value.length; index++) {
              activityList.add(value[index].title);
            }
          })
        });
  }

  void addResume(
      String name,
      String email,
      String phone,
      String profile,
      String categoryIds,
      String activityIds,
      String supportersIds,
      String interestsIds) {
    EasyLoading.show();

    ResumeRepo()
        .addResume(name, email, phone, profile, categoryIds, activityIds,
            supportersIds, interestsIds)
        .then((value) => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DesignResume(
                          value.resumeId.toString(), "0xff63a5e8", false))),
            });
  }

  void updateResume(
      String resumeId,
      String name,
      String email,
      String phone,
      String profile,
      String categoryIds,
      String activityIds,
      String supportersIds,
      String interestsIds) {
    EasyLoading.show();

    ResumeRepo()
        .updateResume(resumeId, name, email, phone, profile, categoryIds,
            activityIds, supportersIds, interestsIds)
        .then((value) => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DesignResume(
                          widget.resumeId.toString(), color, true))),
            });
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      if (widget.resumeId == "0") {
        if (interestList.isEmpty) {
          EasyLoading.showError("Add Interest for adding resume");
        } else {
          addResume(
              nameController.text,
              emailController.text,
              phoneController.text,
              profileController.text,
              categoryController.text,
              activityController.text,
              supporterController.text,
              interestController.text);
        }
      } else {
        updateResume(
            widget.resumeId,
            nameController.text,
            emailController.text,
            phoneController.text,
            profileController.text,
            categoryController.text,
            activityController.text,
            supporterController.text,
            interestController.text);
      }
    }
  }

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var title = "";
          var optionsList = [];
          if (isCategory) {
            title = "Add Category";
            optionsList = categoryList;
          } else if (isInterest) {
            title = "Add Interest";
            optionsList = interestList;
          } else if (isSupporter) {
            title = "Add Supporter";
            optionsList = supporterList;
          } else {
            title = "Add Activity";
            optionsList = activityList;
          }
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
                child: MultiSelectChip(
              optionsList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedGivenList = selectedList;
                  if (isCategory) {
                    categoryController.text = selectedGivenList.join(",");
                  } else if (isActivity) {
                    activityController.text = selectedGivenList.join(",");
                  } else if (isSupporter) {
                    supporterController.text = selectedGivenList.join(",");
                  } else {
                    interestController.text = selectedGivenList.join(",");
                  }
                });
              },
            )),
            actions: <Widget>[
              TextButton(
                child: Text("Add"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  List<String> selectedGivenList = [];

  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ValidConstants.padding),
      ),
      elevation: 0.1,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return SingleChildScrollView(
        child: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(ValidConstants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 2), blurRadius: 5),
              ]),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text("Build Resume", style: GoogleFonts.lato(fontSize: 18)),
                  Container(
                    height: 1,
                    color: AppColors.greyColor,
                    margin: EdgeInsets.only(top: 10),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: nameController,
                        decoration: new InputDecoration(
                          labelText: "Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Name cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: new InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (value) => ValidConstants.isEmail(value)
                            ? null
                            : "Please enter vaild email",
                        keyboardType: TextInputType.emailAddress,
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: new InputDecoration(
                          labelText: "Phone",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (val) {
                          if (val.length != 10) {
                            return "Please enter 10 digit number";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.phone,
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: new ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                          ),
                          child: TextFormField(
                            controller: profileController,
                            maxLength: 100,
                            maxLines: null,
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                              labelText: "Profile",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            validator: (val) {
                              if (val.length == 0) {
                                return "Profile cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          ))),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                          ),
                          child: TextFormField(
                            readOnly: true,
                            maxLines: null,
                            controller: categoryController,
                            onTap: () {
                              isCategory = true;
                              isActivity = false;
                              isSupporter = false;
                              isInterest = false;
                              _showReportDialog();
                            },
                            decoration: new InputDecoration(
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                size: 50,
                              ),
                              labelText: "Select Category",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ))),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 5, top: 4),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Select category in the order that should appear in resume",
                        style: GoogleFonts.lato(fontSize: 12),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                          ),
                          child: TextFormField(
                            maxLines: null,
                            readOnly: true,
                            controller: supporterController,
                            onTap: () {
                              isCategory = false;
                              isActivity = false;
                              isSupporter = true;
                              isInterest = false;
                              _showReportDialog();
                            },
                            decoration: new InputDecoration(
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                size: 50,
                              ),
                              labelText: "Select Supporter",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ))),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                          ),
                          child: TextFormField(
                            readOnly: true,
                            maxLines: null,
                            controller: activityController,
                            onTap: () {
                              isCategory = false;
                              isActivity = true;
                              isSupporter = false;
                              isInterest = false;
                              _showReportDialog();
                            },
                            decoration: new InputDecoration(
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                size: 50,
                              ),
                              labelText: "Select Activity",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ))),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 5, top: 4),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Order your select here is directly appeared in resume",
                          style: GoogleFonts.lato(fontSize: 12),
                          maxLines: 1,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 200.0,
                          ),
                          child: TextFormField(
                            readOnly: true,
                            maxLines: null,
                            controller: interestController,
                            onTap: () {
                              isCategory = false;
                              isActivity = false;
                              isSupporter = false;
                              isInterest = true;
                              _showReportDialog();
                            },
                            decoration: new InputDecoration(
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                size: 50,
                              ),
                              labelText: "Select Interest",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ))),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 5, top: 4),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Order your interest here is directly appeared in resume",
                          style: GoogleFonts.lato(fontSize: 12),
                          maxLines: 1,
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  buttonMenu("Continue", () {
                    validateAndSave();
                  }, context, Colors.black, 200),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
      ],
    ));
  }
}
