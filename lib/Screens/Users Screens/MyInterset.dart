import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/PopUps/InterestPopUp.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/InterestModel.dart';
import 'package:rezzap/Repository/InterestRepo.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Screens/WebScreen/RezzapWeb.dart';

// ignore: must_be_immutable
class MyInterset extends StatefulWidget {
  String id = "0";
  MyInterset(this.id);
  @override
  _MyIntersetState createState() => _MyIntersetState();
}

class _MyIntersetState extends State<MyInterset> {
  List<Interest> interestList = [];

  @override
  void initState() {
    super.initState();
    if (widget.id == "0") {
      showInterestList(false);
    } else {
      showSupporterInterestList();
    }
  }

  void showSupporterInterestList() {
    EasyLoading.show();
    SupporterRepo().getSupporterInterestData(widget.id).then((value) => {
          setState(() {
            EasyLoading.dismiss();
            interestList = value;
          })
        });
  }

  void showInterestList(bool isdeleted) {
    EasyLoading.show();
    InterestRepo().getInterestData().then((value) => {
          setState(() {
            isdeleted
                ? EasyLoading.showInfo("Interest deleted successfully")
                : EasyLoading.dismiss();
            interestList = value;
          })
        });
  }

  void deleteInterest(String interestId) {
    EasyLoading.show();
    InterestRepo()
        .deleteInterest(interestId)
        .then((value) => {showInterestList(true)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
        title: Text(
          (widget.id == "0") ? "MY INTERESTS" : "INTERESTS",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          (widget.id == "0")
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InterestPopUp((value) {
                            if (value == true) {
                              setState(() {
                                showInterestList(false);
                              });
                            }
                            return value;
                          }, false, "", "", "", "");
                        });
                  })
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: interestList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.greenColor,
                            border:
                                Border.all(width: 2.0, color: Colors.grey[200]),
                          ),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RezzapWebView(
                                          interestList[index].url,
                                          "Interest",
                                          false)),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 118,
                                color: Colors.white,
                                margin: EdgeInsets.only(left: 3),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      height: 40,
                                      width: 50,
                                      child: Image.network(
                                          (interestList[index].image == null)
                                              ? Constant.nullImage
                                              : Constant.interestImageUrl +
                                                  interestList[index].image),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        width: (widget.id == "0")
                                            ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                40
                                            : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 +
                                                40,
                                        child: Text(interestList[index].title,
                                            style: GoogleFonts.lato(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500)))
                                  ],
                                ),
                              )),
                        )),
                        SizedBox(
                          width: 5,
                        ),
                        (widget.id == "0")
                            ? Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.greenColor,
                                          border: Border.all(
                                              width: 1.0,
                                              color: Colors.grey[200]),
                                        ),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return InterestPopUp(
                                                        (value) {
                                                      if (value == true) {
                                                        setState(() {
                                                          showInterestList(
                                                              false);
                                                        });
                                                      }
                                                      return value;
                                                    },
                                                        true,
                                                        interestList[index]
                                                            .title,
                                                        interestList[index].url,
                                                        (interestList[index]
                                                                    .image ==
                                                                null)
                                                            ? ""
                                                            : Constant
                                                                    .interestImageUrl +
                                                                interestList[
                                                                        index]
                                                                    .image,
                                                        interestList[index]
                                                            .id
                                                            .toString());
                                                  });
                                            })),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.greenColor,
                                          border: Border.all(
                                              width: 1.0,
                                              color: Colors.grey[200]),
                                        ),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              deleteInterest(interestList[index]
                                                  .id
                                                  .toString());
                                            })),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  );
                })),
      ),
    );
  }
}
