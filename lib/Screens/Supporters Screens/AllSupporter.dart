import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/SupporterModel.dart';
import 'package:rezzap/Repository/SupporterRepo.dart';
import 'package:rezzap/Screens/Supporters%20Screens/AddSupporter.dart';
import 'package:rezzap/Screens/Supporters%20Screens/SupporterProfile.dart';

// ignore: must_be_immutable
class AllSuporters extends StatefulWidget {
  String id = "0";
  AllSuporters(this.id);
  @override
  _AllSuportersState createState() => _AllSuportersState();
}

class _AllSuportersState extends State<AllSuporters> {
  List<Supporter> supportersList = [];

  void initState() {
    super.initState();
    if (widget.id == "0") {
      getSupporterList();
    } else {
      getSuppoertersSupporterList();
    }
  }

  void getSupporterList() {
    EasyLoading.show();
    SupporterRepo().getSupporters().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            supportersList = value;
          })
        });
  }

  void getSuppoertersSupporterList() {
    EasyLoading.show();
    SupporterRepo().getSupportersSupportersList(widget.id).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            supportersList = value;
          })
        });
  }

  void deleteSupporterList(String id) {
    EasyLoading.show();
    SupporterRepo().deleteSupporter(id).then((value) => {getSupporterList()});
  }

  void sendSupporterInvite(String id) {
    EasyLoading.show();
    SupporterRepo().sendSupporterInvite(id).then((value) => {
          getSuppoertersSupporterList(),
          EasyLoading.showInfo("Invite has been sent")
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "ALL SUPPORTERS",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 2,
          backgroundColor: Colors.white,
          actions: [
            (widget.id == "0")
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Addsupporter()),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  )
                : Container()
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: (supportersList.length != 0)
                  ? GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 0.65,
                      children: List.generate(supportersList.length, (index) {
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60.0)),
                              ),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SupporterProfile(
                                                  supportersList[index].id)),
                                    );
                                  },
                                  child: Container(
                                      child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        (supportersList[index].profilePhoto ==
                                                null)
                                            ? Constant.placeHolderImage
                                            : Constant.imageUrl +
                                                supportersList[index]
                                                    .profilePhoto),
                                    radius: 40,
                                  ))),
                            ),
                            Text(
                              supportersList[index].name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            InkWell(
                                onTap: () {
                                  if (widget.id == "0") {
                                    deleteSupporterList(
                                        supportersList[index].id);
                                  } else {
                                    sendSupporterInvite(
                                        supportersList[index].id);
                                  }
                                },
                                child: Container(
                                  color: Colors.black,
                                  height: 30,
                                  width: 100,
                                  child: Center(
                                    child: Text(
                                        (widget.id == "0")
                                            ? 'Remove'
                                            : (supportersList[index].isFollow ==
                                                    1)
                                                ? "Following"
                                                : (supportersList[index]
                                                            .isRequested ==
                                                        1)
                                                    ? "Requested"
                                                    : "Add",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ))
                          ],
                        );
                      }))
                  : InkWell(
                      onTap: () {
                        if (widget.id == "0") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Addsupporter()),
                          );
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Add New Supporter",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Colors.black),
                          ))),
            )
          ],
        ));
  }
}
