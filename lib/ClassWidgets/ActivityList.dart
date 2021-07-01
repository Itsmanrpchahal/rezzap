import 'package:audioplayers/audioplayers.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/PopUps/filterPopUp.dart';
import 'package:rezzap/ClassWidgets/ViewActivity.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/ActivityModel.dart';
import 'package:rezzap/Repository/ActivityRepo.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Screens/Supporters%20Screens/SupporterProfile.dart';
import 'package:rezzap/Screens/Users%20Screens/Comment.dart';
import 'package:rezzap/Screens/WebScreen/RezzapWeb.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class AcitivityList extends StatefulWidget {
  AcitivityList(this.checklist, this.id, this.isAll);
  var checklist = true;
  var isAll = true;
  String id = "0";
  @override
  _MainAcitivityList createState() => _MainAcitivityList();
}

class _MainAcitivityList extends State<AcitivityList>
    with TickerProviderStateMixin {
  List<Activity> activityList = [];
  TextEditingController commentController;
  var supportType = 3;
  var userId = "";
  AnimationController _animationIconController1;
  AudioPlayer audioPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  Duration _slider = new Duration(seconds: 0);
  double durationvalue;
  bool isSongplaying = false;
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    mangeAuidio();
    callDartNotificationCenter();
    getUserId();
    commentController = TextEditingController();
    if (widget.isAll) {
      getAllActivitiesList();
    } else {
      if (widget.id == "0") {
        getActivitiesList();
      } else {
        getSupporterActivitiesList();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
    audioPlayer.stop();
  }

  void getAllActivitiesList() {
    EasyLoading.show();
    ActivityRepo().getAllActivityData().then((value) => {
          getUserId(),
          EasyLoading.dismiss(),
          setState(() {
            activityList = value;
          })
        });
  }

  void callDartNotificationCenter() {
    DartNotificationCenter.subscribe(
      channel: 'activity',
      observer: this,
      onNotification: (options) {
        if (widget.id == "0") {
          getActivitiesList();
        } else {
          getSupporterActivitiesList();
        }
      },
    );
  }

  void mangeAuidio() {
    _position = _slider;
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
      reverseDuration: Duration(milliseconds: 250),
    );
    audioPlayer = new AudioPlayer();

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    audioPlayer.onAudioPositionChanged
        .listen((Duration p) => {setState(() => _position = p)});
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(KeyConstants.userId) ?? '';
  }

  void getActivitiesList() {
    EasyLoading.show();
    ActivityRepo().getActivityData().then((value) => {
          getUserId(),
          EasyLoading.dismiss(),
          setState(() {
            activityList = value;
          })
        });
  }

  void filterActivityList(String id) {
    EasyLoading.show();
    ActivityRepo().getFilterActivityData(id).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            activityList = value;
          })
        });
  }

  void supporterFilterActivityList(String userId, String categoryId) {
    EasyLoading.show();
    ActivityRepo()
        .getSupporterFilterActivityData(userId, categoryId)
        .then((value) => {
              EasyLoading.dismiss(),
              setState(() {
                activityList = value;
              })
            });
  }

  void getSupporterActivitiesList() {
    EasyLoading.show();
    SupporterRepo().getSupporterActivityData(widget.id).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            activityList = value;
          })
        });
  }

  void supportActivity(String id, String supportType) {
    EasyLoading.show();
    ActivityRepo().supportActivity(id, supportType).then((value) => {
          if (widget.isAll)
            {getAllActivitiesList()}
          else
            {
              if (widget.id == "0")
                {getActivitiesList()}
              else
                {getSupporterActivitiesList()}
            }
        });
  }

  void deleteActivity(String activityId) {
    EasyLoading.show();
    ActivityRepo()
        .deleteActivity(activityId)
        .then((value) => {getActivitiesList()});
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        (widget.isAll)
            ? Container(
                margin: EdgeInsets.only(top: 10),
              )
            : Container(
                margin: EdgeInsets.only(top: 10),
                height: 30,
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Filter by category ",
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        iconSize: 20,
                        icon: Icon(Icons.filter),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return FilterWheel((value, categoryId) {
                                  if (value == true) {
                                    if (widget.id == "0") {
                                      if (categoryId != "0") {
                                        filterActivityList(categoryId);
                                      } else {
                                        getActivitiesList();
                                      }
                                    } else {
                                      if (categoryId != "0") {
                                        supporterFilterActivityList(
                                            widget.id, categoryId);
                                      } else {
                                        getSupporterActivitiesList();
                                      }
                                    }
                                  }
                                  return value;
                                }, (widget.id == "0") ? "0" : widget.id);
                              });
                        }),
                  ],
                )),
        (activityList.length != 0)
            ? ListView.builder(
                controller: ScrollController(),
                shrinkWrap: true,
                itemCount: activityList.length,
                itemBuilder: (ctx, index) {
                  var parsedDate =
                      DateTime.parse(activityList[index].eventDate);
                  var year = "${parsedDate.year}";
                  var month = "${parsedDate.month}";
                  var newMonth = int.parse(month);
                  var day = "${parsedDate.day.toString().padLeft(2, '0')}";
                  var utcTime =
                      DateTime.parse(activityList[index].createdAt).toLocal();
                  var time =
                      "${utcTime.hour}:${utcTime.minute.toString().padLeft(2, '0')}";
                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  Constant.months[newMonth - 1],
                                  style: GoogleFonts.lato(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  day,
                                  style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Container(
                                        width: 70,
                                        height: 30,
                                        color: Colors.blue,
                                        child: Center(
                                          child: Text(
                                            year,
                                            style: GoogleFonts.lato(
                                                color: Colors.white),
                                          ),
                                        ))),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                    width: 290,
                                    color: (index % 2 == 0)
                                        ? Colors.yellow[50]
                                        : Colors.blue[50],
                                    child: Column(
                                      children: [
                                        (widget.isAll)
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SupporterProfile(
                                                                activityList[
                                                                        index]
                                                                    .userId)),
                                                  );
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10, left: 18),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: NetworkImage((activityList[
                                                                        index]
                                                                    .profilepic ==
                                                                null)
                                                            ? Constant
                                                                .placeHolderImage
                                                            : Constant
                                                                    .imageUrl +
                                                                activityList[
                                                                        index]
                                                                    .profilepic),
                                                        radius: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Container(
                                                          width: 200,
                                                          child: Text(
                                                              activityList[index]
                                                                      .firstName +
                                                                  " " +
                                                                  activityList[
                                                                          index]
                                                                      .lastName,
                                                              style: GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .blue))),
                                                    ],
                                                  ),
                                                ))
                                            : Container(),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                margin: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    right: 10),
                                                child: Text(
                                                  activityList[index].title,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              (userId ==
                                                      activityList[index]
                                                          .userId)
                                                  ? Container(
                                                      width: 30,
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: IconButton(
                                                          icon: Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            deleteActivity(
                                                                activityList[
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                          }))
                                                  : Container()
                                            ]),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin:
                                              EdgeInsets.only(left: 20, top: 2),
                                          child: Text(
                                            (activityList[index].category ==
                                                    null)
                                                ? ""
                                                : activityList[index].category,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(
                                              left: 20, top: 10),
                                          child: Text(
                                            time,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        if (activityList[index].mediaType ==
                                            "5")
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 10, right: 10),
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => RezzapWebView(
                                                                    Constant.activityPdfUrl +
                                                                        activityList[index]
                                                                            .content,
                                                                    activityList[
                                                                            index]
                                                                        .category,
                                                                    false)));
                                                      },
                                                      child: Text(
                                                        activityList[index]
                                                            .content,
                                                        style: GoogleFonts.lato(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize: 16,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )))),
                                        if (activityList[index].mediaType ==
                                            "7")
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 10, right: 10),
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => RezzapWebView(
                                                                    Constant.activityWordUrl +
                                                                        activityList[index]
                                                                            .content,
                                                                    activityList[
                                                                            index]
                                                                        .category,
                                                                    false)));
                                                      },
                                                      child: Text(
                                                        activityList[index]
                                                            .content,
                                                        style: GoogleFonts.lato(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize: 16,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )))),
                                        if (activityList[index].mediaType ==
                                            "6")
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 10, right: 10),
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => RezzapWebView(
                                                                    activityList[
                                                                            index]
                                                                        .content,
                                                                    activityList[
                                                                            index]
                                                                        .category,
                                                                    false)));
                                                      },
                                                      child: Text(
                                                        activityList[index]
                                                            .content,
                                                        style: GoogleFonts.lato(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize: 16,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )))),
                                        if (activityList[index].mediaType ==
                                            "4")
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 10, right: 10),
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    activityList[index].content,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.left,
                                                  ))),
                                        if (activityList[index].mediaType ==
                                            "1")
                                          InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                        opaque: false,
                                                        pageBuilder: (BuildContext
                                                                    context,
                                                                _,
                                                                __) =>
                                                            ViewActivity(Constant
                                                                    .activityImageUrl +
                                                                activityList[
                                                                        index]
                                                                    .content)));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    right: 10),
                                                child: Image.network(
                                                    Constant.activityImageUrl +
                                                        activityList[index]
                                                            .content),
                                              )),
                                        if (activityList[index].mediaType ==
                                            "3")
                                          Container(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Slider(
                                                  activeColor: Colors.blue,
                                                  inactiveColor: Colors.grey,
                                                  value: _position.inSeconds
                                                      .toDouble(),
                                                  max: _duration.inSeconds
                                                          .toDouble() +
                                                      2,
                                                  onChanged: (double value) {
                                                    setState(() {
                                                      seekToSecond(
                                                          value.toInt());
                                                      value = value;
                                                    });
                                                  },
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(
                                                      () {
                                                        if (!isSongplaying) {
                                                          audioPlayer.play(
                                                              Constant.audioUrl +
                                                                  activityList[
                                                                          index]
                                                                      .content);
                                                        } else {
                                                          audioPlayer.pause();
                                                        }
                                                        isSongplaying
                                                            ? _animationIconController1
                                                                .reverse()
                                                            : _animationIconController1
                                                                .forward();
                                                        isSongplaying =
                                                            !isSongplaying;
                                                      },
                                                    );
                                                  },
                                                  child: ClipOval(
                                                    child: Container(
                                                      color: Colors.blue,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: AnimatedIcon(
                                                          icon: AnimatedIcons
                                                              .play_pause,
                                                          size: 30,
                                                          progress:
                                                              _animationIconController1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (activityList[index].mediaType ==
                                            "2")
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 10, right: 10),
                                              child: FlickVideoPlayer(
                                                  flickManager: FlickManager(
                                                      videoPlayerController:
                                                          VideoPlayerController
                                                              .network(Constant
                                                                      .videoUrl +
                                                                  activityList[
                                                                          index]
                                                                      .content),
                                                      autoPlay: false))),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 10, top: 10),
                                          child: Row(
                                            children: [
                                              Text("Support",
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  activityList[index]
                                                      .supportCount
                                                      .toString(),
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w800)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (activityList[index]
                                                        .isSupport ==
                                                    0) {
                                                  supportType = 1;
                                                } else {
                                                  supportType = 0;
                                                }
                                                supportActivity(
                                                    activityList[index]
                                                        .id
                                                        .toString(),
                                                    supportType.toString());
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(Icons.support),
                                                  Text((activityList[index]
                                                              .isSupport ==
                                                          0)
                                                      ? "Support"
                                                      : "UnSupport")
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserComment(
                                                                activityList[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                activityList[
                                                                        index]
                                                                    .userId)));
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(Icons.comment),
                                                  (activityList[index]
                                                              .commentCount ==
                                                          0)
                                                      ? Text("Comment")
                                                      : (activityList[index]
                                                                  .commentCount ==
                                                              1)
                                                          ? Text(activityList[
                                                                      index]
                                                                  .commentCount
                                                                  .toString() +
                                                              " " +
                                                              "Comment")
                                                          : Text(activityList[
                                                                      index]
                                                                  .commentCount
                                                                  .toString() +
                                                              " " +
                                                              "Comments")
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (activityList[index]
                                                        .mediaType ==
                                                    "1") {
                                                  Share.share(Constant
                                                          .activityImageUrl +
                                                      activityList[index]
                                                          .content);
                                                } else if (activityList[index]
                                                        .mediaType ==
                                                    "2") {
                                                  Share.share(
                                                      Constant.videoUrl +
                                                          activityList[index]
                                                              .content);
                                                } else if (activityList[index]
                                                        .mediaType ==
                                                    "3") {
                                                  Share.share(
                                                      Constant.audioUrl +
                                                          activityList[index]
                                                              .content);
                                                } else if (activityList[index]
                                                        .mediaType ==
                                                    "5") {
                                                  Share.share(
                                                      Constant.activityPdfUrl +
                                                          activityList[index]
                                                              .content);
                                                } else if (activityList[index]
                                                        .mediaType ==
                                                    "7") {
                                                  Share.share(
                                                      Constant.activityWordUrl +
                                                          activityList[index]
                                                              .content);
                                                } else {
                                                  Share.share(
                                                      activityList[index]
                                                          .content);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(Icons.share),
                                                  Text("Share")
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )))
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10,
                              left:
                                  MediaQuery.of(context).size.width / 2 - 100),
                          height: 1,
                          color: Colors.grey[300],
                        )
                      ],
                    ),
                  );
                },
              )
            : Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 70),
                child: Text(
                  "No Activity Found",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.black),
                )),
      ],
    ));
  }
}
