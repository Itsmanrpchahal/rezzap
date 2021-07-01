import 'package:connectivity/connectivity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/SideMenu.dart';
import 'package:rezzap/Models/AllSpin.dart';
import 'package:rezzap/Repository/AllSpinRepo.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Screens/Supporters%20Screens/SupporterProfile.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';
import '../../Common+Store/Colors.dart';

class TheSpin extends StatefulWidget {
  @override
  _TheSpinState createState() => _TheSpinState();
}

class _TheSpinState extends State<TheSpin> {
  int touchedIndex;
  bool isAllSpin = true;
  bool isSearchOn = false;
  List<AllSpin> allSpinList = [];
  List<String> colors = [];
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getAllSpinData();
  }

  void getAllSpinData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      EasyLoading.show();
      AllSpinRepo().getAllSpinData().then((value) => {
            EasyLoading.dismiss(),
            setState(() {
              allSpinList = value;
            })
          });
    } else {
      EasyLoading.showError("No internet connection");
    }
  }

  void sendInviteToUser(String toUser) {
    EasyLoading.show();
    SupporterRepo().sendSupporterInvite(toUser).then((value) => {
          EasyLoading.dismiss(),
          EasyLoading.showInfo("Request send successfully")
        });
  }

  void getSearchSpinData(String keyword) {
    EasyLoading.show();
    AllSpinRepo().getSearchSpinData(keyword).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            allSpinList = value;
          })
        });
  }

  void getMySpinData() {
    EasyLoading.show();
    AllSpinRepo().getMySpinData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            allSpinList = value;
          })
        });
  }

  void followUnfollowUser(String id, String statusType) {
    EasyLoading.show();
    AllSpinRepo()
        .userFollowUnfollow(id, statusType)
        .then((value) => {getAllSpinData()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 1,
          title: (isSearchOn)
              ? Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Row(children: [
                    Expanded(
                        child: Container(
                            height: 20,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: TextFormField(
                              controller: searchController,
                              style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  hintText: 'Search',
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black))),
                            ))),
                    InkWell(
                        onTap: () {
                          setState(() {
                            isSearchOn = !isSearchOn;
                            getSearchSpinData(searchController.text);
                          });
                        },
                        child: Container(
                          color: AppColors.greenColor,
                          height: 30,
                          width: 60,
                          child: Center(
                            child: Text('search',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ))
                  ]))
              : Text(
                  "THE SPIN",
                  style: TextStyle(color: Colors.black),
                ),
          backgroundColor: Colors.white,
          actions: [
            (!isSearchOn)
                ? IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearchOn = !isSearchOn;
                      });
                    })
                : Container()
          ],
        ),
        drawer: SideDrawer(),
        body: Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Filter",
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        SizedBox(
                          width: 10,
                        ),
                        buttonMenu("All Spin", () {
                          setState(() {
                            isAllSpin = true;
                            getAllSpinData();
                          });
                        },
                            context,
                            isAllSpin ? Colors.green[400] : Colors.grey[400],
                            130),
                        SizedBox(
                          width: 10,
                        ),
                        buttonMenu("My Spin", () {
                          setState(() {
                            isAllSpin = false;
                            getMySpinData();
                          });
                        },
                            context,
                            isAllSpin ? Colors.grey[400] : Colors.green[400],
                            130)
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
              (allSpinList.length != 0) ? Expanded(
                    child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 0.67,
                        children: List.generate(allSpinList.length, (index) {
                          return InkWell(
                              onTap: () {
                                if (allSpinList[index].visibility == "0" ||
                                    allSpinList[index].isFollow == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SupporterProfile(
                                            allSpinList[index].userId)),
                                  );
                                } else {
                                  EasyLoading.showInfo(
                                      "${allSpinList[index].name} account is not public");
                                }
                              },
                              child: Card(
                                  margin: EdgeInsets.all(10),
                                  elevation: 3,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        margin: EdgeInsets.only(top: 30),
                                        child: PieChart(
                                          PieChartData(
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 20,
                                              sections: (allSpinList[index]
                                                          .graphList
                                                          .length !=
                                                      0)
                                                  ? List.generate(
                                                      allSpinList[index]
                                                          .graphList
                                                          .length, (indexx) {
                                                      colors.add(
                                                          allSpinList[index]
                                                              .graphList[indexx]
                                                              .color
                                                              .replaceAll(
                                                                  "#", "0xff"));

                                                      return PieChartSectionData(
                                                        color: Color(int.parse(
                                                            colors[indexx])),
                                                        showTitle: false,
                                                        title: allSpinList[
                                                                    index]
                                                                .graphList[
                                                                    indexx]
                                                                .percentage +
                                                            "%",
                                                        radius: 20,
                                                        titleStyle: TextStyle(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xffffffff)),
                                                      );
                                                    })
                                                  : List.generate(1, (indexx) {
                                                      return PieChartSectionData(
                                                        color: Colors.grey[400],
                                                        showTitle: false,
                                                        radius: 20,
                                                      );
                                                    })),
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        margin: EdgeInsets.only(
                                            top: 30, left: 5, right: 5),
                                        child: Text(
                                          allSpinList[index].name,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (allSpinList[index].visibility ==
                                              "1") {
                                            sendInviteToUser(
                                                allSpinList[index].userId);
                                          } else {
                                            if (allSpinList[index].isFollow ==
                                                0) {
                                              followUnfollowUser(
                                                  allSpinList[index].userId,
                                                  "1");
                                            } else {
                                              followUnfollowUser(
                                                  allSpinList[index].userId,
                                                  "0");
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.greenColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          margin: EdgeInsets.only(top: 5),
                                          height: 30,
                                          width: 100,
                                          child: Center(
                                            child: Text(
                                              (allSpinList[index].isRequested ==
                                                      1)
                                                  ? "Requested"
                                                  : (allSpinList[index]
                                                              .isFollow ==
                                                          0)
                                                      ? "Follow"
                                                      : "Following",
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )));
                        }))):Container(
                alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  child: Text(
                    "No Spin Found",
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black),
                  )),
              ],
            )));
  }
}
