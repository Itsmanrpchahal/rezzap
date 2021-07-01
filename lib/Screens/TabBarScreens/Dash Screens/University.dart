import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/PopUps/CollegePopup.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/Colleges.dart';
import 'package:rezzap/Repository/CollegeRepo.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

// ignore: must_be_immutable
class UniversityList extends StatefulWidget {
  String avgGpa = "";
  String satMath = "";
  String satCritical = "";
  String actComposite = "";
  String suscribed = "";
  UniversityList(this.avgGpa, this.satMath, this.satCritical, this.actComposite,
      this.suscribed);
  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList> {
  List<College> collegeList = [];
  List<String> schoolList = [];
  List<String> stateList = [];
  List _selectedIndexs = [];
  List<String> dreamCollegesId = [];
  bool isDreamColleges = false;

  double avgGpa = 0;
  int satMath = 0;
  int satCritical = 0;
  int actComposite = 0;

  TextEditingController collegeController;
  TextEditingController stateController;
  TextEditingController schoolTypeController;
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    collegeController = TextEditingController();
    stateController = TextEditingController();
    schoolTypeController = TextEditingController();
    searchController = TextEditingController();
    setIncomingData();
    getAllCollegeList();
    getSateList();
    getSchoolList();
  }

  void setIncomingData() {
    avgGpa = double.parse(widget.avgGpa);
    satMath = int.parse(widget.satMath);
    satCritical = int.parse(widget.satCritical);
    actComposite = int.parse(widget.actComposite);
  }

  void getAllCollegeList() {
    EasyLoading.show();
    _selectedIndexs = [];
    CollegeRepo().getCollegesData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            isDreamColleges = false;
            collegeList = value;
          })
        });
  }

  void searchAllCollegeList(String keyword) {
    EasyLoading.show();
    CollegeRepo().searchAllCollegesData(keyword).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            isDreamColleges = false;
            collegeList = value;
          })
        });
  }

  void searchBySchoolCollegeCollegeList(String state, String schoolType) {
    EasyLoading.show();
    CollegeRepo().searchByStateSchoolData(state, schoolType).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            isDreamColleges = false;
            collegeList = value;
          })
        });
  }

  void getSchoolList() {
    CollegeRepo().getSchoolData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            for (var index = 0; index < value.length; index++) {
              schoolList.add(value[index].schoolType);
            }
          })
        });
  }

  void getSateList() {
    EasyLoading.show();
    CollegeRepo().getSateData().then((value) => {
          setState(() {
            for (var index = 0; index < value.length; index++) {
              stateList.add(value[index].state);
            }
          })
        });
  }

  void getDreamCollegeList() {
    EasyLoading.show();
    CollegeRepo().getDreamCollegesData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            isDreamColleges = true;
            collegeList = value;
          })
        });
  }

  void addDreamColleges(String ids) {
    EasyLoading.show();
    dreamCollegesId = [];
    _selectedIndexs = [];
    CollegeRepo().addDreamColleges(ids).then((value) => {getAllCollegeList()});
  }

  void deleteDreamCollege(String id) {
    EasyLoading.show();
    CollegeRepo()
        .deleteDreamColleges(id)
        .then((value) => getDreamCollegeList());
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("COLLEGE LIST", true),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              Container(
                  height: 48,
                  margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                  color: Colors.black,
                  child: Container(
                      margin: EdgeInsets.only(left: 15, right: 10, top: 2),
                      child: TextFormField(
                        controller: searchController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500),
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (searchController.text.isEmpty) {
                                  EasyLoading.showError(
                                      "Enter valid colege name");
                                } else {
                                  searchAllCollegeList(searchController.text);
                                }
                              },
                              icon: Icon(Icons.search),
                              color: Colors.white,
                              iconSize: 30,
                            )),
                        keyboardType: TextInputType.emailAddress,
                      ))),
              Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: stateController,
                      readOnly: true,
                      onTap: () {},
                      decoration: new InputDecoration(
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                            size: 30,
                          ),
                          onSelected: (String value) {
                            stateController.text = value;
                          },
                          itemBuilder: (BuildContext context) {
                            return stateList
                                .map<PopupMenuItem<String>>((String value) {
                              return new PopupMenuItem(
                                  child: new Text(value), value: value);
                            }).toList();
                          },
                        ),
                        labelText: "State",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: schoolTypeController,
                      readOnly: true,
                      onTap: () {},
                      decoration: new InputDecoration(
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                            size: 30,
                          ),
                          onSelected: (String value) {
                            schoolTypeController.text = value;
                          },
                          itemBuilder: (BuildContext context) {
                            return schoolList
                                .map<PopupMenuItem<String>>((String value) {
                              return new PopupMenuItem(
                                  child: new Text(value), value: value);
                            }).toList();
                          },
                        ),
                        labelText: "School",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(),
                        ),
                      ),
                    )),
                    IconButton(
                        iconSize: 30,
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (stateController.text.isEmpty &&
                              schoolTypeController.text.isEmpty) {
                            EasyLoading.showError(
                                "Please fill required deatils");
                          } else {
                            searchBySchoolCollegeCollegeList(
                                stateController.text,
                                schoolTypeController.text);
                          }
                        })
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: collegeController,
                        readOnly: true,
                        onTap: () {},
                        decoration: new InputDecoration(
                          suffixIcon: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                              size: 30,
                            ),
                            onSelected: (String value) {
                              collegeController.text = value;
                              if (collegeController.text ==
                                  Constant.colleges[0]) {
                                getAllCollegeList();
                              } else {
                                getDreamCollegeList();
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return Constant.colleges
                                  .map<PopupMenuItem<String>>((String value) {
                                return new PopupMenuItem(
                                    child: new Text(value), value: value);
                              }).toList();
                            },
                          ),
                          labelText: "Colleges",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      (widget.suscribed != "suscribed")
                          ? Container()
                          : buttonMenu("Request", () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CollegePopUp();
                                  });
                            }, context, Colors.black, 100)
                    ],
                  )),
              ListView.builder(
                itemCount: collegeList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final _isSelected = _selectedIndexs.contains(index);
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(right: 15, left: 15, top: 15),
                    child: Column(
                      children: [
                        Container(
                            height: 50,
                            color: (isDreamColleges)
                                ? AppColors.greenColor
                                : (_isSelected)
                                    ? AppColors.greenColor
                                    : Colors.blue,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            child: InkWell(
                                onTap: () {
                                  if (!isDreamColleges) {
                                    setState(() {
                                      if (_isSelected) {
                                        _selectedIndexs.remove(index);
                                        dreamCollegesId.removeWhere((item) =>
                                            item ==
                                            collegeList[index].id.toString());
                                      } else {
                                        _selectedIndexs.add(index);
                                        dreamCollegesId.add(
                                            collegeList[index].id.toString());
                                      }
                                    });
                                  } else {
                                    deleteDreamCollege(
                                        collegeList[index].id.toString());
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 5, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: Text(
                                                collegeList[index].collegeName,
                                                style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        (isDreamColleges)
                                            ? Image.asset(
                                                'assets/images/collegeFill.png')
                                            : Image.asset((_isSelected)
                                                ? 'assets/images/collegeFill.png'
                                                : 'assets/images/college.png'),
                                      ],
                                    )))),
                        Container(
                            height: 30,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Acceptance Rate %",
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                            collegeList[index].acceptanceRate),
                                      ),
                                    )
                                  ],
                                ))),
                        Container(
                            height: 30,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Avg GPA",
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      width: 60,
                                      color: (collegeList[index].avgGPA.isEmpty)
                                          ? Colors.red
                                          : (avgGpa <
                                                  double.parse(
                                                      collegeList[index]
                                                          .avgGPA))
                                              ? Colors.red
                                              : (avgGpa > 10)
                                                  ? Colors.yellow
                                                  : Colors.green,
                                      child: Center(
                                        child: Text(
                                          collegeList[index].avgGPA,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ))),
                        Container(
                            height: 30,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("SAT Math",
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      width: 60,
                                      color: (collegeList[index]
                                              .satMath
                                              .isEmpty)
                                          ? Colors.red
                                          : (satMath <
                                                  int.parse(collegeList[index]
                                                      .satMath))
                                              ? Colors.red
                                              : (satMath >= 1000)
                                                  ? Colors.yellow
                                                  : Colors.green,
                                      child: Center(
                                        child: Text(collegeList[index].satMath,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    )
                                  ],
                                ))),
                        Container(
                            height: 30,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("SAT Critical",
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      width: 60,
                                      color: (collegeList[index]
                                              .satCritical
                                              .isEmpty)
                                          ? Colors.red
                                          : (satCritical <
                                                  int.parse(collegeList[index]
                                                      .satCritical))
                                              ? Colors.red
                                              : (satCritical >= 1000)
                                                  ? Colors.yellow
                                                  : Colors.green,
                                      child: Center(
                                        child: Text(
                                            collegeList[index].satCritical,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    )
                                  ],
                                ))),
                        Container(
                            height: 30,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("ACT Composite",
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      width: 60,
                                      color: (collegeList[index]
                                              .actComposite
                                              .isEmpty)
                                          ? Colors.red
                                          : (actComposite <
                                                  int.parse(collegeList[index]
                                                      .actComposite))
                                              ? Colors.red
                                              : (actComposite >= 100)
                                                  ? Colors.yellow
                                                  : Colors.green,
                                      child: Center(
                                        child: Text(
                                            collegeList[index].actComposite,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    )
                                  ],
                                ))),
                        Container(
                            height: 30,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("State",
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        collegeList[index].state,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ))),
                        Container(
                            height: 30,
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("School Type",
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        collegeList[index].schoolType,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.end,
                                      ),
                                    )
                                  ],
                                ))),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        )),
        floatingActionButton: (isDreamColleges)
            ? Container()
            : FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.school),
                backgroundColor: Colors.blue,
                onPressed: () {
                  var ids = dreamCollegesId.join(',');
                  addDreamColleges(ids);
                }));
  }
}
