import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/ActivityList.dart';
import 'package:rezzap/ClassWidgets/SideMenu.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Repository/UserRepo.dart';
import 'package:rezzap/Screens/Supporters%20Screens/AllSupporter.dart';
import 'package:rezzap/Screens/Users%20Screens/MyInterset.dart';
import 'package:rezzap/Screens/Users%20Screens/UserProfile.dart';
import 'package:rezzap/Screens/Users%20Screens/UserSpin.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String account = "";
  String profilePic = "";
  List<String> accounType = Constant.accountType;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
  
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      EasyLoading.show();
      UserRepo().getUserData().then((value) => {
            EasyLoading.dismiss(),
            setState(() {
              userName = value.firstName + " " + value.lastName;
              profilePic = value.profilePhoto;
              final accountType = value.accountType;
              var accountId = int.parse(accountType);
              account = accounType[accountId - 1];
              print("object");
            })
          });
    } else {
      EasyLoading.showError("No Internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home",style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 5),
              child: IconButton(
                  icon: Image.asset("assets/images/add-group.png"),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllSuporters("0")),
                    );
                  })),
        ],
      ),
      drawer: SideDrawer(),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfile((value) {
                              if (value == true) {
                                getUserData();
                              }
                              return true;
                            })),
                  );
                },
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/roundBg.png",
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 34, left: 33),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        backgroundImage: NetworkImage((profilePic == null)
                            ? Constant.placeHolderImage
                            : Constant.imageUrl + profilePic),
                        radius: 66,
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  userName,
                  maxLines: 2,
                  style: GoogleFonts.lato(fontSize: 25, color: Colors.black),
                )),
            SizedBox(
              height: 5,
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  account,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.w700),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonMenu("Interest", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyInterset("0")),
                  );
                }, context, AppColors.primaryColor,
                    MediaQuery.of(context).size.width / 2 - 20),
                SizedBox(
                  width: 10,
                ),
                buttonMenu("My Wheel", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserSpin(true, "0")),
                  );
                }, context, Colors.blue,
                    MediaQuery.of(context).size.width / 2 - 20),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: 5,
              color: Colors.grey[200],
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2 + 50,
                child: AcitivityList(true, "0", true)),
          ],
        ),
      )),
    );
  }
}
