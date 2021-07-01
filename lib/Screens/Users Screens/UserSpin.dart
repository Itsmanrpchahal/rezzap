import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rezzap/ClassWidgets/ActivityList.dart';
import 'package:rezzap/ClassWidgets/PopUps/CategoryPopUp.dart';
import 'package:rezzap/Models/CategoryModel.dart';
import 'package:rezzap/Repository/CategoryRepo.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Screens/Users%20Screens/AddActivity.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

// ignore: must_be_immutable
class UserSpin extends StatefulWidget {
  var checkUserSpin = true;
  String id = "0";
  UserSpin(this.checkUserSpin, this.id);
  @override
  _UserSpinState createState() => _UserSpinState();
}

class _UserSpinState extends State<UserSpin> {
  int touchedIndex;
  List<Category> categoryList = [];
  List<CategorySpin> categoryGraphList = [];
  List<String> colors = [];
  List<String> graphColors = [];

  @override
  void initState() {
    super.initState();

    if (widget.id == "0") {
      showCategoryGraph();
    } else {
      showSupporterCategoryList();
      showSupporterCategoryGraph();
    }
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

  void showSupporterCategoryGraph() {
    EasyLoading.show();
    SupporterRepo().getSupporterCategoryGraph(widget.id).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            categoryGraphList = value;
          })
        });
  }

  void showCategoryList() {
    EasyLoading.show();
    CategoryRepo().showCategoryData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            colors = [];
            categoryList = value;
          })
        });
  }

  void showCategoryGraph() {
    EasyLoading.show();
    CategoryRepo().getCategoryGraph().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            categoryGraphList = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.checkUserSpin
          ? AppBar(
              centerTitle: true,
              title: Text(
                "MY WHEEL",
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              elevation: 2,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddActivity((value) {
                                  if (value == true) {
                                    DartNotificationCenter.post(
                                      channel: "activity",
                                      options: 'with options!!',
                                    );
                                  }
                                  return true;
                                })),
                      );
                    }),
                IconButton(
                    icon: Image.asset('assets/images/addSpin.png'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CategoryDialogBox((value) {
                              if (value == true) {
                                showCategoryList();
                              }
                              return value;
                            });
                          });
                    })
              ],
            )
          : null,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    setState(() {
                      if (pieTouchResponse.touchInput is FlLongPressEnd ||
                          pieTouchResponse.touchInput is FlPanEnd) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse.touchedSectionIndex;
                      }
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 80,
                  sections: showingSections()),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey[400],
          ),
          (widget.id == "0")
              ? Container(
                  height: MediaQuery.of(context).size.height / 2 + 50,
                  child: AcitivityList(true, "0", false))
              : Container(
                  margin: EdgeInsets.only(left: 20),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    itemCount: categoryList.length,
                    itemBuilder: (ctx, index) {
                      colors.add(
                          categoryList[index].color.replaceAll("#", "0xff"));
                      return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Column(children: [
                            Indicator(
                              isStart: true,
                              color: Color(int.parse(colors[index])),
                              text: categoryList[index].title,
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ]));
                    },
                  ),
                ),
        ],
      )),
    );
  }

  List<PieChartSectionData> showingSections() {
    return (categoryGraphList.length != 0)
        ? List.generate(categoryGraphList.length, (index) {
            final isTouched = index == touchedIndex;
            final double fontSize = isTouched ? 15 : 12;
            final double radius = isTouched ? 80 : 70;
            graphColors
                .add(categoryGraphList[index].color.replaceAll("#", "0xff"));
            return PieChartSectionData(
              color: Color(int.parse(graphColors[index])),
              value: categoryGraphList[index].activityCount.toDouble(),
              title: (isTouched)
                  ? categoryGraphList[index].categoryName
                  : categoryGraphList[index].percentage + "%",
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: (isTouched) ? Colors.black : const Color(0xffffffff)),
            );
          })
        : List.generate(1, (indexx) {
            return PieChartSectionData(
              color: Colors.grey[400],
              showTitle: false,
              radius: 70,
            );
          });
  }
}
