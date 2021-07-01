import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Screens/Users%20Screens/Support%20Activity/PostActivity.dart';
import 'package:rezzap/Screens/Users%20Screens/Support%20Activity/RecentActivity.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

class SupportActivity extends StatefulWidget {
  @override
  _SupportActivityState createState() => _SupportActivityState();
}

class _SupportActivityState extends State<SupportActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("SUPPORT ACTIVITY", true),
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(top: 20),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: TabBar(
                        tabs: [
                          Tab(
                              child: Text(
                            "Support Activity",
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )),
                          Tab(
                              child: Text(
                            "Recent Activity",
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )),
                        ],
                        indicatorColor: AppColors.greenColor,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [PostActivity(), RecentActivity()]),
                    ),
                  ],
                ),
              ))
              ),
    );
  }
}
