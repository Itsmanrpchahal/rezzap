import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/ActivityList.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Screens/Supporters%20Screens/AllSupporter.dart';
import 'package:rezzap/Screens/Supporters%20Screens/SupporterDetails.dart';
import 'package:rezzap/Screens/Users%20Screens/MyInterset.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';
import '../../Common+Store/Colors.dart';
import '../Users Screens/UserSpin.dart';

// ignore: must_be_immutable
class SupporterProfile extends StatefulWidget {
  String id = "";
  SupporterProfile(this.id);
  @override
  _SupporterProfileState createState() => _SupporterProfileState();
}

class _SupporterProfileState extends State<SupporterProfile> {
  bool isFirstIndex = true;
  String userName = "";
  String account = "";
  String profilePic = "";
  int isfollow = 0;
  List<String> accounType = Constant.accountType;
  String title = "Profile";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    EasyLoading.show();
    SupporterRepo().getSupporterData(widget.id).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            userName = value.firstName + " " + value.lastName;
            profilePic = value.profilePhoto;
            isfollow = value.isFollow;
            final accountType = value.accountType;
            var accountId = int.parse(accountType);
            account = accounType[accountId - 1];
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title, true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
              child: Image.network(
                (profilePic == null)
                    ? Constant.placeHolderImage
                    : Constant.imageUrl + profilePic,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            )),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2 + 20,
                      child: Text(
                        userName,
                        style: GoogleFonts.lato(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      )),
                  Container(
                    child: Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            color: AppColors.greenColor,
                            child: Image.asset('assets/images/follow.png')),
                        Text(
                          (isfollow == 0) ? " Follow" : " Following",
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5,
                left: 20,
              ),
              child: Text(
                account,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttonMenu("Interest", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyInterset(widget.id)),
                    );
                  }, context, AppColors.primaryColor,
                      MediaQuery.of(context).size.width / 2 - 30),
                  buttonMenu("Supporters", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllSuporters(widget.id)),
                    );
                  }, context, AppColors.greenColor,
                      MediaQuery.of(context).size.width / 2 - 30),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: 5,
              color: Colors.grey[200],
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: TabBar(
                      onTap: (value) {
                        setState(() {
                          // if (value == 0) {
                          //   isFirstIndex = true;
                          //   title = "Profile";
                          // } else if (value == 1) {
                          //   title = "Timeline";
                          //   isFirstIndex = false;
                          // } else {
                          //   title = "Wheel";
                          //   isFirstIndex = false;
                          // }

                          if (value == 0) {
                            isFirstIndex = true;
                            title = "Timeline";
                          } else {
                            title = "Wheel";
                            isFirstIndex = false;
                          }
                        });
                      },
                      tabs: [
                        // Tab(
                        //     child: Text(
                        //   "Details",
                        //   style: GoogleFonts.lato(
                        //       fontSize: 16,
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.w500),
                        // )),
                        Tab(
                            child: Text(
                          "Timeline",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                        Tab(
                            child: Text(
                          "Wheel",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                      ],
                      indicatorColor: AppColors.greenColor,
                    ),
                  ),
                  Container(
                    height: isFirstIndex
                        ? MediaQuery.of(context).size.height
                        : MediaQuery.of(context).size.height / 2 + 50,
                    child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // AbsorbPointer(
                          //   child: SupporterDetails(widget.id),
                          //   absorbing: true,
                          // ),
                          AcitivityList(false, widget.id, false),
                          UserSpin(false, widget.id),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
