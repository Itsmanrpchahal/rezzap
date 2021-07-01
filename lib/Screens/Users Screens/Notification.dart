import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/Notification.dart';
import 'package:rezzap/Repository/NotificationRepo.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

class UserNotifications extends StatefulWidget {
  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  
  List<Notif> notificationList = [];

  void getNotificationList() {
    EasyLoading.show();
    NotificationRepo().getUserNotifications().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            if (value.length != 0) {
              notificationList = value;
            } else {
              notificationList = value;
              EasyLoading.showInfo("You currently have no notification");
            }
          })
        });
  }

  void sendInviteToUser(String toUser) {
    EasyLoading.show();
    SupporterRepo()
        .sendSupporterInvite(toUser)
        .then((value) => {EasyLoading.showInfo("Request send successfully")});
  }

  void deleteAllNotifications() {
    EasyLoading.show();
    NotificationRepo()
        .deleteAllNotifications()
        .then((value) => {getNotificationList()});
  }

  void deleteSingleNotification(String id) {
    EasyLoading.show();
    NotificationRepo().deleteSingleNotifications(id).then((value) => {
          EasyLoading.showInfo("Notification deleted Successfully"),
          getNotificationList()
        });
  }

  void acceptOrDeclineRequest(String toUser, String statusType, String name) {
    EasyLoading.show();
    NotificationRepo()
        .accpetOrDeclineRequest(toUser, statusType)
        .then((value) => {
              EasyLoading.dismiss(),
              if (statusType == "1")
                {EasyLoading.showInfo("$name Added as supporter")},
              getNotificationList()
            });
  }

  @override
  void initState() {
    super.initState();
    getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("NOTIFICATIONS", true),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notificationList.length,
          itemBuilder: (ctx, index) {
            return Dismissible(
                background: Container(color: Colors.red),
                key: Key(notificationList[index].id),
                onDismissed: (direction) {
                  deleteSingleNotification(
                      notificationList[index].notificationId.toString());
                },
                child: Container(
                  height: 70,
                  child: Card(
                      elevation: 2,
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  backgroundImage: NetworkImage(
                                      (notificationList[index].profilePhoto ==
                                              null)
                                          ? Constant.placeHolderImage
                                          : Constant.imageUrl +
                                              notificationList[index]
                                                  .profilePhoto),
                                  radius: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                    width: (notificationList[index]
                                                    .isSupporter ==
                                                false) ||
                                            (notificationList[index].type ==
                                                "follower")
                                        ? MediaQuery.of(context).size.width / 2
                                        : MediaQuery.of(context).size.width -
                                            80,
                                    child: Text(
                                        notificationList[index].notification,
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500))),
                              ],
                            ),
                            (notificationList[index].isSupporter == false && (notificationList[index].type == "following"))
                                ? InkWell(
                                    onTap: () {
                                        sendInviteToUser(
                                                notificationList[index].id);
                                          
                                    },
                                    child: Container(
                                      color: AppColors.primaryColor,
                                      height: 30,
                                      width: 100,
                                      child: Center(
                                        child: Text('Support Back',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ))
                                : (notificationList[index].type == "follower") 
                                    ? Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                acceptOrDeclineRequest(
                                                    notificationList[index]
                                                        .id
                                                        .toString(),
                                                    "1",
                                                    notificationList[index]
                                                        .name);
                                              },
                                              child: Container(
                                                color: AppColors.greenColor,
                                                height: 30,
                                                width: 50,
                                                child: Center(
                                                  child: Text('confirm',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                acceptOrDeclineRequest(
                                                    notificationList[index]
                                                        .id
                                                        .toString(),
                                                    "0",
                                                    notificationList[index]
                                                        .name);
                                              },
                                              child: Container(
                                                color: Colors.red,
                                                height: 30,
                                                width: 50,
                                                child: Center(
                                                  child: Text('decline',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                              ))
                                        ],
                                      )
                                    : Container()
                          ],
                        ),
                      )),
                ));
          },
        ),
      ),
      floatingActionButton: (notificationList.length != 0)
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              elevation: 2,
              child: Icon(Icons.delete_forever),
              onPressed: () {
                deleteAllNotifications();
              },
            )
          : Container(),
    );
  }
}
