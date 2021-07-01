import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/PopUps/ResumePopUp.dart';
import 'package:rezzap/ClassWidgets/SideMenu.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/ResumeModel.dart';
import 'package:rezzap/Repository/ResumeRepo.dart';
import 'package:url_launcher/url_launcher.dart';

class MyResume extends StatefulWidget {
  @override
  _MyResumeState createState() => _MyResumeState();
}

class _MyResumeState extends State<MyResume> {
  List _selectedIndexs = [];

  List<Resume> resumeList = [];

  void getResumeList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      EasyLoading.show();
      ResumeRepo().getUserResume().then((value) => {
            EasyLoading.dismiss(),
            setState(() {
              resumeList = value;
            })
          });
    } else {
      EasyLoading.showError("No internet connection");
    }
  }

  void deleteResume(String id) {
    EasyLoading.show();
    ResumeRepo().deleteResume(id).then((value) => {getResumeList()});
  }

  void initState() {
    super.initState();
    getResumeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 2,
        title: Text(
          "MY RESUMES",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Image.asset('assets/images/addCV.png'),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ResumePopUp("0");
                    });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: (resumeList.length != 0)
              ? ListView.builder(
                  itemCount: resumeList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final _isSelected = _selectedIndexs.contains(index);
                    var createdDate =
                        DateTime.parse(resumeList[index].createdAt).toLocal();
                    var updatedDate =
                        DateTime.parse(resumeList[index].updatededAt).toLocal();
                    var newUpdatedDate =
                        "${updatedDate.day.toString().padLeft(2, '0')}-${updatedDate.month.toString().padLeft(2, '0')}-${updatedDate.year} at ${updatedDate.hour}:${updatedDate.minute.toString().padLeft(2, '0')}";
                    var newCreatedDate =
                        "${createdDate.day.toString().padLeft(2, '0')}-${createdDate.month..toString().padLeft(2, '0')}-${createdDate.year} at ${createdDate.hour}:${createdDate.minute.toString().padLeft(2, '0')}";
                    return Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              height: 4,
                              color: AppColors.greenColor,
                            ),
                            Container(
                              height: 85,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.grey[300]),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(resumeList[index].name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ))),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(newUpdatedDate.toString(),
                                          maxLines: 1,
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      Text(newCreatedDate.toString(),
                                          maxLines: 1,
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    if (_isSelected) {
                                      _selectedIndexs.remove(index);
                                    } else {
                                      _selectedIndexs.add(index);
                                    }
                                  });
                                },
                                child: (!_isSelected)
                                    ? Container(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                120,
                                        color: AppColors.greenColor,
                                        child: Center(
                                            child: Text(
                                          "view more",
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: Colors.white),
                                        )),
                                      )
                                    : Container(
                                        height: 80,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                120,
                                        color: AppColors.greenColor,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                    icon: Icon(Icons.edit),
                                                    color: Colors.white,
                                                    iconSize: 30,
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ResumePopUp(
                                                                resumeList[
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                          });
                                                    }),
                                                IconButton(
                                                    icon: Image.asset(
                                                        'assets/images/pdf.png'),
                                                    iconSize: 30,
                                                    onPressed: () {
                                                      print(
                                                          Constant.pdfResumeD +
                                                              resumeList[index]
                                                                  .id
                                                                  .toString());
                                                      launch(
                                                          Constant.pdfResumeD +
                                                              resumeList[index]
                                                                  .id
                                                                  .toString());
                                                    }),
                                                IconButton(
                                                    icon: Image.asset(
                                                        'assets/images/word.png'),
                                                    iconSize: 30,
                                                    onPressed: () {
                                                      print(
                                                          Constant.wordResumeD +
                                                              resumeList[index]
                                                                  .id
                                                                  .toString());
                                                      launch(
                                                          Constant.pdfResumeD +
                                                              resumeList[index]
                                                                  .id
                                                                  .toString());
                                                    }),
                                                IconButton(
                                                    icon: Icon(Icons.delete),
                                                    color: Colors.white,
                                                    iconSize: 30,
                                                    onPressed: () {
                                                      deleteResume(
                                                          resumeList[index]
                                                              .id
                                                              .toString());
                                                    })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "view more",
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )),
                          ],
                        ));
                  },
                )
              : Container(
                alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  child: Text(
                    "No Resume Found",
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black),
                  )),
        ),
      ),
    );
  }
}
