import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/SideMenu.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/CategoryModel.dart';
import 'package:rezzap/Repository/CollegeRepo.dart';
import 'package:rezzap/Screens/WebScreen/RezzapWeb.dart';

class Dash extends StatefulWidget {
  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  TextEditingController controller = new TextEditingController();

  List<CategorySpin> categoryGraphList = [];
  List<String> graphColors = [];
  bool isScoreedited = false;
  int touchedIndex;
  bool isPopUp = false;
  String selectedIndex = "";

  File personalFilePick;
  String personalFileName = "";
  String personalFile = "";

  String professionalFile = "";
  File professionalFilePick;
  String professionalFileName = "";

  String academicFile = "";
  File academicFilePick;
  String academicFileName = "";

  String awardsFile = "";
  File awardFilePick;
  String awardFileName = "";

  String otherFile = "";
  File otherFilePick;
  String otherFileName = "";

  String subscription = "";

  void initState() {
    super.initState();
    getAllFiles();
  }

  void postTestFiles(String uplaodType, File selectedFile) {
    EasyLoading.show();
    CollegeRepo().addFiles(uplaodType, selectedFile).then((value) => {
          getAllFiles(),
          EasyLoading.showInfo("File uplaoded successfully"),
        });
  }

  void deleteTestFiles(String id) {
    EasyLoading.show();
    CollegeRepo().deleteTestFiles(id).then((value) =>
        {getAllFiles(), EasyLoading.showInfo("File deleted successfully")});
  }

  void getAllFiles() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      EasyLoading.show();
      CollegeRepo().getAllFiles().then((value) => {
            EasyLoading.dismiss(),
            setState(() {
              personalFile = value.personal;
              professionalFile = value.professional;
              academicFile = value.academic;
              awardsFile = value.awards;
              otherFile = value.other;
            })
          });
    } else {
      EasyLoading.showError("No internet connection");
    }
  }

  Future _pickAcademicFile() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'jpeg'],
    );
    if (file != null) {
      setState(() {
        academicFilePick = File(file.files.single.path);
        academicFileName = file.files.single.name;
      });
    } else {}
  }

  Future _pickProfessionalFile() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'jpeg'],
    );
    if (file != null) {
      setState(() {
        professionalFilePick = File(file.files.single.path);
        professionalFileName = file.files.single.name;
      });
    } else {}
  }

  Future _pickPersonalFile() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'jpeg'],
    );
    if (file != null) {
      setState(() {
        personalFilePick = File(file.files.single.path);
        personalFileName = file.files.single.name;
      });
    } else {}
  }

  Future _pickAwardFile() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'jpeg'],
    );
    if (file != null) {
      setState(() {
        awardFilePick = File(file.files.single.path);
        awardFileName = file.files.single.name;
      });
    } else {}
  }

  Future _pickOtherFile() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'jpeg'],
    );
    if (file != null) {
      setState(() {
        otherFilePick = File(file.files.single.path);
        otherFileName = file.files.single.name;
      });
    } else {}
  }

  List<PieChartSectionData> showingSections1() {
    return List.generate(5, (index) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 150 : 140;
      if (isTouched) {
        setState(() {
          isPopUp = !isPopUp;
          if (index == 0) {
            selectedIndex = "Personal";
          } else if (index == 1) {
            selectedIndex = "Professional";
          } else if (index == 2) {
            selectedIndex = "Academic";
          } else if (index == 3) {
            selectedIndex = "Awards";
          } else {
            selectedIndex = "Other";
          }
        });
      }
      switch (index) {
        case 0:
          return PieChartSectionData(
            color: (personalFile == null) ? Colors.red : Colors.green,
            title: 'Personal',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: (professionalFile == null) ? Colors.red : Colors.green,
            title: 'Professional',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: (academicFile == null) ? Colors.red : Colors.green,
            title: 'Academic',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: (awardsFile == null) ? Colors.red : Colors.green,
            title: 'Awards',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: (otherFile == null) ? Colors.red : Colors.green,
            title: 'Other',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DASH",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
      drawer: SideDrawer(),
      body: Container(
        child: Column(
          mainAxisAlignment: (!isPopUp) ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            (!isPopUp)
                ? AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData:
                              PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              if (pieTouchResponse.touchInput
                                      is FlLongPressEnd ||
                                  pieTouchResponse.touchInput is FlPanEnd) {
                                touchedIndex = -1;
                              } else {
                                touchedIndex =
                                    pieTouchResponse.touchedSectionIndex;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: showingSections1()),
                    ),
                  )
                : (selectedIndex == "Personal")
                    ? Container(
                        margin: EdgeInsets.only(top: 30, left: 15, right: 15),
                        decoration: BoxDecoration(
                          color: AppColors.greenColor,
                          border:
                              Border.all(width: 1.0, color: Colors.grey[200]),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  _pickPersonalFile();
                                },
                                child: Container(
                                    height: 60,
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                                child: Text("Personal File",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                            (personalFilePick != null)
                                                ? Text(personalFileName,
                                                    style: GoogleFonts.lato(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500))
                                                : Text(
                                                    (personalFile == null)
                                                        ? "Click here to upload file"
                                                        : personalFile,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500))
                                          ]),
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    icon: Image.asset(
                                        'assets/images/fileUpload.png'),
                                    onPressed: () {
                                      if (personalFilePick != null) {
                                        postTestFiles("1", personalFilePick);
                                      } else {
                                        EasyLoading.showError(
                                            "Please select formatted file from device");
                                      }
                                    }),
                                IconButton(
                                    icon: Icon(Icons.file_present),
                                    color: Colors.white,
                                    onPressed: () {
                                      if (personalFile == null) {
                                        EasyLoading.showError("No file found");
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RezzapWebView(
                                                      Constant.personal +
                                                          personalFile,
                                                      "Personal File",false)),
                                        );
                                      }
                                    }),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () {
                                      if (personalFile == null) {
                                        EasyLoading.showError("No file found");
                                      } else {
                                        deleteTestFiles("1");
                                      }
                                    }),
                                IconButton(
                                    icon: Icon(Icons.refresh),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        isPopUp = !isPopUp;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ))
                    : (selectedIndex == "Professional")
                        ? Container(
                            margin:
                                EdgeInsets.only(top: 30, left: 15, right: 15),
                            decoration: BoxDecoration(
                              color: AppColors.greenColor,
                              border: Border.all(
                                  width: 1.0, color: Colors.grey[200]),
                            ),
                            child: Column(children: [
                              InkWell(
                                  onTap: () {
                                    _pickProfessionalFile();
                                  },
                                  child: Container(
                                    height: 60,
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: Text(
                                                      "Professional File",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              (professionalFilePick != null)
                                                  ? Text(professionalFileName,
                                                      style: GoogleFonts.lato(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500))
                                                  : Text(
                                                      (professionalFile == null)
                                                          ? "Click here to upload file"
                                                          : professionalFile,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500))
                                            ])),
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      icon: Image.asset(
                                          'assets/images/fileUpload.png'),
                                      onPressed: () {
                                        if (professionalFilePick != null) {
                                          postTestFiles(
                                              "2", professionalFilePick);
                                        } else {
                                          EasyLoading.showError(
                                              "Please select formatted file from device");
                                        }
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.file_present),
                                      color: Colors.white,
                                      onPressed: () {
                                        if (professionalFile == null) {
                                          EasyLoading.showError(
                                              "No file found");
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RezzapWebView(
                                                        Constant.prefessional +
                                                            professionalFile,
                                                        "Professional File",false)),
                                          );
                                        }
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.white,
                                      onPressed: () {
                                        if (professionalFile == null) {
                                          EasyLoading.showError(
                                              "No file found");
                                        } else {
                                          deleteTestFiles("2");
                                        }
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.refresh),
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          isPopUp = !isPopUp;
                                        });
                                      }),
                                ],
                              ),
                            ]))
                        : (selectedIndex == "Academic")
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 30, left: 15, right: 15),
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  border: Border.all(
                                      width: 1.0, color: Colors.grey[200]),
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          _pickAcademicFile();
                                        },
                                        child: Container(
                                          height: 60,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          color: Colors.white,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                        child: Text(
                                                            "Academic File",
                                                            style: GoogleFonts.lato(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))),
                                                    (academicFilePick != null)
                                                        ? Text(academicFileName,
                                                            style: GoogleFonts.lato(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))
                                                        : Text(
                                                            (academicFile ==
                                                                    null)
                                                                ? "Click here to upload file"
                                                                : academicFile,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))
                                                  ])),
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                            icon: Image.asset(
                                                'assets/images/fileUpload.png'),
                                            onPressed: () {
                                              if (academicFilePick != null) {
                                                postTestFiles(
                                                    "3", academicFilePick);
                                              } else {
                                                EasyLoading.showError(
                                                    "Please select formatted file from device");
                                              }
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.file_present),
                                            color: Colors.white,
                                            onPressed: () {
                                              if (academicFile == null) {
                                                EasyLoading.showError(
                                                    "No file found");
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RezzapWebView(
                                                              Constant.academics +
                                                                  academicFile,
                                                              "Academic File",false)),
                                                );
                                              }
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.white,
                                            onPressed: () {
                                              if (academicFile == null) {
                                                EasyLoading.showError(
                                                    "No file found");
                                              } else {
                                                deleteTestFiles("3");
                                              }
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.refresh),
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                isPopUp = !isPopUp;
                                              });
                                            }),
                                      ],
                                    ),
                                  ],
                                ))
                            : (selectedIndex == "Awards")
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: 30, left: 15, right: 15),
                                    decoration: BoxDecoration(
                                      color: AppColors.greenColor,
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[200]),
                                    ),
                                    child: Column(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              _pickAwardFile();
                                            },
                                            child: Container(
                                              height: 60,
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              color: Colors.white,
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                            child: Text(
                                                                "Award File",
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500))),
                                                        (awardFilePick != null)
                                                            ? Text(
                                                                awardFileName,
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500))
                                                            : Text(
                                                                (awardsFile ==
                                                                        null)
                                                                    ? "Click here to upload file"
                                                                    : awardsFile,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500))
                                                      ])),
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                                icon: Image.asset(
                                                    'assets/images/fileUpload.png'),
                                                onPressed: () {
                                                  if (awardFilePick != null) {
                                                    postTestFiles(
                                                        "4", awardFilePick);
                                                  } else {
                                                    EasyLoading.showError(
                                                        "Please select formatted file from device");
                                                  }
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.file_present),
                                                color: Colors.white,
                                                onPressed: () {
                                                  if (awardsFile == null) {
                                                    EasyLoading.showError(
                                                        "No file found");
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RezzapWebView(
                                                                  Constant.awards +
                                                                      awardsFile,
                                                                  "Award File",false)),
                                                    );
                                                  }
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.delete),
                                                color: Colors.white,
                                                onPressed: () {
                                                  if (awardsFile == null) {
                                                    EasyLoading.showError(
                                                        "No file found");
                                                  } else {
                                                    deleteTestFiles("4");
                                                  }
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.refresh),
                                                color: Colors.white,
                                                onPressed: () {
                                                  setState(() {
                                                    isPopUp = !isPopUp;
                                                  });
                                                }),
                                          ],
                                        ),
                                      ],
                                    ))
                                : Container(
                                    margin: EdgeInsets.only(
                                        top: 30, left: 15, right: 15),
                                    decoration: BoxDecoration(
                                      color: AppColors.greenColor,
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[200]),
                                    ),
                                    child: Column(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              _pickOtherFile();
                                            },
                                            child: Container(
                                              height: 60,
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              color: Colors.white,
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                            child: Text(
                                                                "Other File",
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500))),
                                                        (otherFilePick != null)
                                                            ? Text(otherFileName,
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500))
                                                            : Text(
                                                                (otherFile ==
                                                                        null)
                                                                    ? "Click here to upload file"
                                                                    : otherFile,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500))
                                                      ])),
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                                icon: Image.asset(
                                                    'assets/images/fileUpload.png'),
                                                onPressed: () {
                                                  if (otherFilePick != null) {
                                                    postTestFiles(
                                                        "5", otherFilePick);
                                                  } else {
                                                    EasyLoading.showError(
                                                        "Please select formatted file from device");
                                                  }
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.file_present),
                                                color: Colors.white,
                                                onPressed: () {
                                                  if (otherFile == null) {
                                                    EasyLoading.showError(
                                                        "No file found");
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RezzapWebView(
                                                                  Constant.other +
                                                                      otherFile,
                                                                  "Other File",false)),
                                                    );
                                                  }
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.delete),
                                                color: Colors.white,
                                                onPressed: () {
                                                  if (otherFile == null) {
                                                    EasyLoading.showError(
                                                        "No file found");
                                                  } else {
                                                    deleteTestFiles("5");
                                                  }
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.refresh),
                                                color: Colors.white,
                                                onPressed: () {
                                                  setState(() {
                                                    isPopUp = !isPopUp;
                                                  });
                                                }),
                                          ],
                                        ),
                                      ],
                                    )),
          ],
        ),
      ),
    );
  }
}
