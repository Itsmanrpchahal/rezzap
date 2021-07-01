import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/SupporterModel.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Screens/Supporters%20Screens/SupporterProfile.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

class Addsupporter extends StatefulWidget {
  @override
  _AddsupporterState createState() => _AddsupporterState();
}

class _AddsupporterState extends State<Addsupporter> {
  TextEditingController searchController;
  List<Supporter> supportersList = [];

  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  void searchSupporterList(String keyword) {
    EasyLoading.show();
    SupporterRepo().inviteSupporter(keyword).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            supportersList = value;
          })
        });
  }

  void sendInviteToUser(String toUser) {
    EasyLoading.show();
    SupporterRepo().sendSupporterInvite(toUser).then((value) => {
          searchSupporterList(searchController.text),
          EasyLoading.showInfo("Request send successfully")
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Find SUPPORTER", true),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Supporter name",
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
              Container(
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
                    buttonMenu("Search", () {
                      if (searchController.text.isEmpty) {
                        EasyLoading.showError("Please enter name");
                      } else {
                        searchSupporterList(searchController.text);
                      }
                    }, context, Colors.black, 100)
                  ])),
              SizedBox(height: 30),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: supportersList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                        onTap: () {
                          if (supportersList[index].visibility == "0") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SupporterProfile(
                                      supportersList[index].userId)),
                            );
                          } else {
                            EasyLoading.showInfo(
                                "${supportersList[index].firstName + " " + supportersList[index].lastName} account is not public");
                          }
                        },
                        child: Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Card(
                              elevation: 2,
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              (supportersList[index]
                                                          .profilePhoto ==
                                                      null)
                                                  ? Constant.placeHolderImage
                                                  : Constant.imageUrl +
                                                      supportersList[index]
                                                          .profilePhoto),
                                          radius: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            child: Text(
                                                supportersList[index]
                                                        .firstName +
                                                    " " +
                                                    supportersList[index]
                                                        .lastName,
                                                style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    color: Colors.black))),
                                      ],
                                    ),
                                    InkWell(
                                        onTap: () {
                                          if ((supportersList[index].isFollow ==
                                              0)) {
                                            sendInviteToUser(
                                                supportersList[index].userId);
                                          }
                                        },
                                        child: Container(
                                          color: AppColors.greenColor,
                                          height: 30,
                                          width: 110,
                                          child: Center(
                                            child: Text(
                                                (supportersList[index]
                                                            .isFollow ==
                                                        1)
                                                    ? "Following"
                                                    : (supportersList[index]
                                                                .isRequested ==
                                                            1)
                                                        ? 'Requested'
                                                        : 'send request',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ))
                                  ],
                                ),
                              )),
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
