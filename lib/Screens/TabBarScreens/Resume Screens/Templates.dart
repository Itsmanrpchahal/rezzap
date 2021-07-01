import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/TemplateModel.dart';
import 'package:rezzap/Repository/ResumeRepo.dart';
import 'package:rezzap/Screens/TabBarScreens/HomeTabBar.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Template extends StatefulWidget {
  Color screenPickerColor;
  String optionType = "";
  String resumeId = "";
  Template(this.screenPickerColor, this.optionType, this.resumeId);
  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  var profilePic = "";
  List<SupporterList> supportersList = [];
  List<CategoryList> categoryList = [];
  List<IntersetList> interestList = [];
  String profile = "";
  String name = "";
  String phoneNumber = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getResumeData();
  }

  void getResumeData() {
    EasyLoading.show();
    ResumeRepo().getResumeData(widget.resumeId).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            getUserData();
            supportersList = value.supporterList;
            categoryList = value.categoryList;
            interestList = value.interestList;
            profile = value.resumeProfile;
            name = value.resumeName;
            phoneNumber = value.resumePhone;
            email = value.resumeEmail;
          })
        });
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profilePic = Constant.imageUrl + prefs.getString(KeyConstants.profilePic);
  }

  void addTemplateResume(String resumeId, String templateId, String color) {
    EasyLoading.show();
    ResumeRepo()
        .addTemplateResume(resumeId, templateId, color)
        .then((value) => {
              EasyLoading.showInfo("Updated succefully"),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeTabBar(3)),
              )
            });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(children: [
          Column(
            crossAxisAlignment: (widget.optionType == "3")
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                color: (widget.optionType == "1")
                    ? widget.screenPickerColor
                    : Colors.white,
                height: (widget.optionType == "1") ? 150 : 200,
                child: (widget.optionType == "1")
                    ? Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Image.network(
                              profilePic,
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                width: (widget.optionType == "1")
                                    ? MediaQuery.of(context).size.width / 2 - 50
                                    : null,
                                child: Text(
                                  name,
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: (widget.optionType == "1")
                                          ? Colors.white
                                          : widget.screenPickerColor,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 80,
                                alignment: Alignment.topRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      email,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      phoneNumber,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                )),
                          ],
                        ))
                    : Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Column(
                          mainAxisAlignment: (widget.optionType == "3")
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          crossAxisAlignment: (widget.optionType == "3")
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              profilePic,
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              name,
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: (widget.optionType == "1")
                                      ? Colors.white
                                      : widget.screenPickerColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 50,
                                child: Column(
                                  crossAxisAlignment: (widget.optionType == "2")
                                      ? CrossAxisAlignment.center
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      email,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: (widget.optionType == "1")
                                              ? Colors.white
                                              : widget.screenPickerColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      phoneNumber,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: (widget.optionType == "1")
                                              ? Colors.white
                                              : widget.screenPickerColor,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                )),
                          ],
                        )),
              ),
              (widget.optionType == "2")
                  ? Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 1,
                      color: widget.screenPickerColor,
                    )
                  : Container(),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: (widget.optionType == "1")
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  profile,
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ))
                          ],
                        )
                      : Column(
                          mainAxisAlignment: (widget.optionType == "3")
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          crossAxisAlignment: (widget.optionType == "3")
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Profile",
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                alignment: (widget.optionType == "3")
                                    ? Alignment.bottomLeft
                                    : Alignment.center,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  profile,
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ))
                          ],
                        )),
              (widget.optionType == "3")
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 1,
                      color: widget.screenPickerColor,
                    ),
              Container(
                child: ListView.builder(
                    itemCount: categoryList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 15),
                              child: (widget.optionType == "1")
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: 100,
                                            child: Text(
                                              categoryList[index].name,
                                              style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                            height: (categoryList[index]
                                                        .activityList
                                                        .length <=
                                                    3)
                                                ? 70
                                                : 130,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              child: GridView.count(
                                                  physics: (categoryList[index]
                                                              .activityList
                                                              .length <=
                                                          3)
                                                      ? NeverScrollableScrollPhysics()
                                                      : null,
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 1,
                                                  children: List.generate(
                                                      categoryList[index]
                                                          .activityList
                                                          .length, (indexx) {
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      margin: EdgeInsets.all(5),
                                                      child: (categoryList[
                                                                      index]
                                                                  .activityList[
                                                                      indexx]
                                                                  .mediaType ==
                                                              "3")
                                                          ? Icon(
                                                              Icons
                                                                  .ad_units_rounded,
                                                              size: 50,
                                                            )
                                                          : (categoryList[index]
                                                                      .activityList[
                                                                          indexx]
                                                                      .mediaType ==
                                                                  "2")
                                                              ? Icon(
                                                                  Icons
                                                                      .videocam,
                                                                  size: 50,
                                                                )
                                                              : (categoryList[index]
                                                                          .activityList[
                                                                              indexx]
                                                                          .mediaType ==
                                                                      "4")
                                                                  ? Icon(
                                                                      Icons
                                                                          .text_format,
                                                                      size: 50,
                                                                    )
                                                                  : (categoryList[index]
                                                                              .activityList[indexx]
                                                                              .mediaType ==
                                                                          "1")
                                                                      ? Icon(
                                                                          Icons
                                                                              .image,
                                                                          size:
                                                                              50,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .file_copy,
                                                                          size:
                                                                              50,
                                                                        ),
                                                    );
                                                  })),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          (widget.optionType == "3")
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          (widget.optionType == "3")
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          categoryList[index].name,
                                          style: GoogleFonts.lato(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                            height: (categoryList[index]
                                                        .activityList
                                                        .length <=
                                                    3)
                                                ? 70
                                                : 150,
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              child: GridView.count(
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 1.4,
                                                  physics: (categoryList[index]
                                                              .activityList
                                                              .length <=
                                                          3)
                                                      ? NeverScrollableScrollPhysics()
                                                      : null,
                                                  children: List.generate(
                                                      categoryList[index]
                                                          .activityList
                                                          .length, (indexx) {
                                                    return Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: (categoryList[
                                                                      index]
                                                                  .activityList[
                                                                      indexx]
                                                                  .mediaType ==
                                                              "3")
                                                          ? Icon(
                                                              Icons
                                                                  .ad_units_rounded,
                                                              size: 50,
                                                            )
                                                          : (categoryList[index]
                                                                      .activityList[
                                                                          indexx]
                                                                      .mediaType ==
                                                                  "2")
                                                              ? Icon(
                                                                  Icons
                                                                      .videocam,
                                                                  size: 50,
                                                                )
                                                              : (categoryList[index]
                                                                          .activityList[
                                                                              indexx]
                                                                          .mediaType ==
                                                                      "4")
                                                                  ? Icon(
                                                                      Icons
                                                                          .text_format,
                                                                      size: 50,
                                                                    )
                                                                  : (categoryList[index]
                                                                              .activityList[indexx]
                                                                              .mediaType ==
                                                                          "1")
                                                                      ? Icon(
                                                                          Icons
                                                                              .image,
                                                                          size:
                                                                              50,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .file_copy,
                                                                          size:
                                                                              50,
                                                                        ),
                                                    );
                                                  })),
                                            )),
                                      ],
                                    )),
                          (widget.optionType == "3")
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 1,
                                  color: widget.screenPickerColor,
                                ),
                        ],
                      );
                    }),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: (widget.optionType == "1")
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Supporter",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 + 50,
                            child: ListView.builder(
                                itemCount: supportersList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: Container(
                                        child: Text(
                                      supportersList[index].name,
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    )),
                                  );
                                }),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: (widget.optionType == "3")
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        crossAxisAlignment: (widget.optionType == "3")
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Supporter",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 + 50,
                            child: ListView.builder(
                                itemCount: supportersList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: (widget.optionType == "3")
                                        ? Alignment.bottomLeft
                                        : Alignment.center,
                                    margin: EdgeInsets.all(5),
                                    child: Container(
                                        child: Text(
                                      supportersList[index].name,
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    )),
                                  );
                                }),
                          ),
                        ],
                      ),
              ),
              (widget.optionType == "3")
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 1,
                      color: widget.screenPickerColor,
                    ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: (widget.optionType == "1")
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Interest",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 + 50,
                            child: ListView.builder(
                                itemCount: interestList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: Container(
                                        child: Text(
                                      interestList[index].name,
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    )),
                                  );
                                }),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: (widget.optionType == "3")
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        crossAxisAlignment: (widget.optionType == "3")
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Interest",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: ListView.builder(
                                itemCount: interestList.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.all(5),
                                    child: Container(
                                        child: Text(
                                      interestList[index].name,
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    )),
                                  );
                                }),
                          ),
                        ],
                      ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          buttonMenu("Save", () {
            addTemplateResume(widget.resumeId, widget.optionType,
                '#${widget.screenPickerColor.value.toRadixString(16)}');
          }, context, Colors.black, 200),
          SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }
}
