import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/UserModel.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SupporterDetails extends StatefulWidget {
  String id = "";
  SupporterDetails(this.id);
  @override
  _SupporterDetailsState createState() => _SupporterDetailsState();
}

class _SupporterDetailsState extends State<SupporterDetails> {
  TextEditingController birthdayController;
  TextEditingController locationController;
  TextEditingController mobileController;
  TextEditingController genderController;
  TextEditingController addressController;
  TextEditingController streetController;
  TextEditingController zipCodeController;
  TextEditingController visibilityController;
  TextEditingController schoolController;
  TextEditingController collegeController;
  TextEditingController degreeController;
  TextEditingController desginationController;
  List<String> accounType = Constant.accountType;
  List<String> designations = Constant.designations;

  void initState() {
    super.initState();
    birthdayController = TextEditingController();
    visibilityController = TextEditingController();
    genderController = TextEditingController();
    locationController = TextEditingController();
    mobileController = TextEditingController();
    addressController = TextEditingController();
    zipCodeController = TextEditingController();
    streetController = TextEditingController();
    schoolController = TextEditingController();
    collegeController = TextEditingController();
    degreeController = TextEditingController();
    desginationController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder<User>(
            future: SupporterRepo().getSupporterData(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                mobileController.text = snapshot.data.mobile;
                schoolController.text = snapshot.data.highschool;
                collegeController.text = snapshot.data.college;
                degreeController.text = snapshot.data.degree;
                streetController.text = snapshot.data.street;
                addressController.text = snapshot.data.address;
                birthdayController.text = snapshot.data.dob;
                genderController.text =
                    snapshot.data.gender == "1" ? "Male" : "Female";

                visibilityController.text =
                    snapshot.data.visibility == "0" ? "Public" : "Private";
                if (snapshot.data.designation != null) {
                  var desgignation = int.parse(snapshot.data.designation);
                  desginationController.text = designations[desgignation];
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          height: 50,
                          color: Colors.grey[200],
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.location_searching)),
                              Text(
                                "   Location :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                          readOnly: true,
                                          controller: locationController,
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Not Available'))))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.calendar_today_sharp)),
                              Text(
                                "   DOB :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        controller: birthdayController,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        readOnly: true,
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          color: Colors.grey[200],
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.verified_user_rounded)),
                              Text(
                                "   Gender :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 3.5),
                                      child: TextFormField(
                                        controller: genderController,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                (snapshot.data.gender == "1")
                                                    ? "Male"
                                                    : "Female"),
                                        readOnly: true,
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.phone)),
                              Text(
                                "   Mobile :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        controller: mobileController,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          color: Colors.grey[200],
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.mail)),
                              Text(
                                "   Email :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        readOnly: true,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: snapshot.data.email),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.apps)),
                              Text(
                                "   Rezzap :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        readOnly: true,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: snapshot.data.rezzapId),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          color: Colors.grey[200],
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.business)),
                              Text(
                                "   High School :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        controller: schoolController,
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Not Available'),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.school_sharp)),
                              Text(
                                "   College :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        controller: collegeController,
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Not Available'),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          color: Colors.grey[200],
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.pages_sharp)),
                              Text(
                                "   Degree :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        controller: degreeController,
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Not Available'),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.work)),
                              Text(
                                "   Designation :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 3.5),
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: desginationController,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Not Available'),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          color: Colors.grey[200],
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.home)),
                              Text(
                                "   Address :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: TextFormField(
                                        controller: addressController,
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Not Available'),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.add_road_sharp)),
                              Text(
                                "   Sreet :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: TextFormField(
                                        controller: streetController,
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Not Available'),
                                      )))
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          color: Colors.grey[200],
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.visibility)),
                              Text(
                                "   Visibily :",
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Expanded(
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 3.5),
                                      child: TextFormField(
                                        controller: visibilityController,
                                        readOnly: true,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                (snapshot.data.visibility ==
                                                        "1")
                                                    ? "Private"
                                                    : "Public"),
                                      )))
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                EasyLoading.show();
                return Text("");
              }
            }));
  }
}
