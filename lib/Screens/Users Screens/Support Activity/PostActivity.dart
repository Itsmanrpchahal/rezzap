import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Models/SupportModel.dart';
import 'package:rezzap/Repository/SupportRepo.dart';
import 'package:rezzap/Screens/Supporters%20Screens/SupporterProfile.dart';

class PostActivity extends StatefulWidget {
  @override
  _PostActivityState createState() => _PostActivityState();
}

class _PostActivityState extends State<PostActivity> {
  Support postList;

  @override
  void initState() {
    super.initState();
    getLikedPostData();
  }

  void getLikedPostData() async {
    EasyLoading.show();
    SupportRepo().getSupportActivityData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            postList = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: (postList == null)
              ? Center(
                  child: Text(
                  "No post Found",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.black),
                ))
              : GroupListView(
                  sectionsCount: postList.data.keys.toList().length,
                  countOfItemInSection: (int section) {
                    return postList.data.values.toList()[section].length;
                  },
                  itemBuilder: (BuildContext context, IndexPath index) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SupporterProfile(postList
                                    .data.values
                                    .toList()[index.section][index.index]
                                    .userId)),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(postList
                                          .data.values
                                          .toList()[index.section][index.index]
                                          .imgUrl),
                                      radius: 30,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            alignment: Alignment.topLeft,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 +
                                                100,
                                            child: Text(
                                                postList.data.values
                                                    .toList()[index.section]
                                                        [index.index]
                                                    .person,
                                                style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.blue[900]))),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                            alignment: Alignment.topLeft,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 +
                                                100,
                                            child: RichText(
                                              textAlign: TextAlign.start,
                                              text: new TextSpan(
                                                style: new TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                      text: postList.data.values
                                                          .toList()[
                                                              index.section]
                                                              [index.index]
                                                          .message,
                                                      style: new TextStyle(
                                                          color: AppColors
                                                              .greenColor,
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
                                  margin: EdgeInsets.only(top: 10),
                                  height: 1,
                                  color: Colors.grey[200],
                                )
                              ],
                            )));
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
                              postList.data.keys.toList()[section],
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
