import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';
import '../../Models/CategoryModel.dart';
import '../../Repository/CategoryRepo.dart';

// ignore: camel_case_types
typedef checkValue = bool Function(bool, String);

// ignore: must_be_immutable
class FilterWheel extends StatefulWidget {
  checkValue callback;
  String id = "0";
  FilterWheel(this.callback, this.id);
  @override
  FilterWheelBoxState createState() => FilterWheelBoxState();
}

class FilterWheelBoxState extends State<FilterWheel> {
  List<Category> categoryList = [];
  List<String> colors = [];

  @override
  void initState() {
    super.initState();
    if (widget.id == "0") {
      showCategoryList();
    } else {
      showSupporterCategoryList();
    }
  }

  void showCategoryList() {
    EasyLoading.show();
    CategoryRepo().showCategoryData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            categoryList = value;
          })
        });
  }

  void showSupporterCategoryList() {
    EasyLoading.show();
    SupporterRepo().getSupporterCategoryData(widget.id).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            categoryList = value;
          })
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
              borderRadius: BorderRadius.circular(ValidConstants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 2), blurRadius: 5),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text("FILTER INTEREST", style: GoogleFonts.lato(fontSize: 18)),
              Container(
                height: 1,
                color: AppColors.greyColor,
                margin: EdgeInsets.only(top: 10),
              ),
              SizedBox(
                height: 15,
              ),
              (categoryList.length == 0)
                  ? Container(
                      height: 200,
                    )
                  : Column(
                      children: [
                        InkWell(
                            onTap: () {
                              widget.callback(true, "0");
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Indicator(
                                    isStart: true,
                                    color: AppColors.greenColor,
                                    text: "All activity",
                                    isSquare: true))),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: categoryList.length,
                          itemBuilder: (ctx, index) {
                            colors.add(categoryList[index]
                                .color
                                .replaceAll("#", "0xff"));
                            return Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Column(children: [
                                  InkWell(
                                      onTap: () {
                                        widget.callback(true,
                                            categoryList[index].id.toString());
                                        Navigator.of(context).pop();
                                      },
                                      child: Indicator(
                                        isStart: true,
                                        color: Color(int.parse(colors[index])),
                                        text: categoryList[index].title,
                                        isSquare: true,
                                      )),
                                  SizedBox(
                                    height: 10,
                                  )
                                ]));
                          },
                        )
                      ],
                    ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ],
    );
  }
}
