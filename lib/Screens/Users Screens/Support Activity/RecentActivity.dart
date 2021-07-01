import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:rezzap/Common+Store/Colors.dart';

class RecentActivity extends StatefulWidget {
  @override
  _RecentActivityState createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (true)
          ? Center(
              child: Text(
              "No Post Found",
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.black),
            ))
          : Container(
              child: GroupListView(
              sectionsCount: 10,
              countOfItemInSection: (int section) {
                return 3;
              },
              itemBuilder: (BuildContext context, IndexPath index) {
                return Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://pbs.twimg.com/media/EvcizDkWQAABXn3.jpg"),
                                  radius: 30,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 +
                                                50,
                                        child: Text("Copper latham",
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.blue[900]))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 +
                                                50,
                                        child: RichText(
                                          textAlign: TextAlign.start,
                                          text: new TextSpan(
                                            style: new TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: 'has supported this ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                              new TextSpan(
                                                  text: 'Activity Name',
                                                  style: new TextStyle(
                                                      color:
                                                          AppColors.greenColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 200,
                              margin:
                                  EdgeInsets.only(top: 10, left: 15, right: 15),
                              child: Image.network(
                                "https://pbs.twimg.com/media/EvcizDkWQAABXn3.jpg",
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 1,
                          color: Colors.grey[200],
                        )
                      ],
                    ));
              },
              groupHeaderBuilder: (BuildContext context, int section) {
                return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 1,
                          color: Colors.black,
                        ),
                        Text(
                          " 10  April 202 ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: 1,
                          color: Colors.black,
                        ),
                      ],
                    ));
              },
              separatorBuilder: (context, index) => SizedBox(height: 1),
              sectionSeparatorBuilder: (context, section) =>
                  SizedBox(height: 10),
            )),
    );
  }
}
