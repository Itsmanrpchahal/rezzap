import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/SignIn.dart';
import 'package:rezzap/Screens/Users%20Screens/Notification.dart';
import 'package:rezzap/Screens/Users%20Screens/Support%20Activity/SupportActivity.dart';
import 'package:rezzap/Screens/WebScreen/RezzapWeb.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatelessWidget {
  logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(KeyConstants.userLoggedIn);
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation animation, Animation secondaryAnimation) {
          return SignIn();
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }),
        (Route route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          ListTile(
            leading: Icon(
              Icons.notification_important,
              color: Colors.black,
            ),
            title: Text(
              'NOTIFICATIONS',
              style: GoogleFonts.lato(fontSize: 18, color: Colors.black),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserNotifications()),
              )
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            leading: Icon(
              Icons.local_activity,
              color: Colors.black,
            ),
            title: Text(
              'SUPPORT ACTIVITY',
              style: GoogleFonts.lato(fontSize: 18, color: Colors.black),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportActivity()),
              )
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            leading: Icon(
              Icons.help,
              color: Colors.black,
            ),
            title: Text('HELP',
                style: GoogleFonts.lato(fontSize: 18, color: Colors.black)),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RezzapWebView(Constant.webBase + "help", "Help", true)),
              ),
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            leading: Icon(
              Icons.question_answer,
              color: Colors.black,
            ),
            title: Text('FAQ',
                style: GoogleFonts.lato(fontSize: 18, color: Colors.black)),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RezzapWebView(Constant.webBase + "faq", "FAQ", true)),
              ),
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            leading: Icon(
              Icons.privacy_tip,
              color: Colors.black,
            ),
            title: Text('PRIVACY POLICY',
                style: GoogleFonts.lato(fontSize: 18, color: Colors.black)),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RezzapWebView(
                        Constant.webBase + "privacy-policy",
                        "Privacy Policy",
                        true)),
              ),
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: Text('SIGN OUT',
                style: GoogleFonts.lato(fontSize: 18, color: Colors.black)),
            onTap: () {
              logoutUser(context);
            },
          ),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
       
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: MaterialButton(
                  onPressed: () => {},
                  child: Container(
                    height: 100,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Text("FOLLOW US",
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Colors.black)),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              icon: Image.asset('assets/images/facebook.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RezzapWebView(
                                          "https://www.facebook.com/Rezzap-1517672048539007",
                                          "REZZAP",
                                          false)),
                                );
                              },
                            ),
                            IconButton(
                              iconSize: 40,
                              icon: Image.asset('assets/images/twitter.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RezzapWebView(
                                          "https://twitter.com/officialrezzap",
                                          "REZZAP",
                                          false)),
                                );
                              },
                            ),
                            IconButton(
                              iconSize: 40,
                              icon: Image.asset('assets/images/instagram.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RezzapWebView(
                                          "https://www.instagram.com/officialrezzap/",
                                          "REZZAP",
                                          false)),
                                );
                              },
                            ),
                            IconButton(
                              iconSize: 40,
                              icon: Image.asset('assets/images/pintrest.png'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RezzapWebView(
                                          "https://www.pinterest.com/officialrezzap/",
                                          "REZZAP",
                                          false)),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
