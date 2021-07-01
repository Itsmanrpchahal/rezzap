import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/CommonPrefrence.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/InitialScreen.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/SignIn.dart';
import 'package:rezzap/Screens/TabBarScreens/HomeTabBar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final splashDelay = 2;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _controller.repeat(reverse: true);
    _loadWidget();
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Future loginstatus = SharedPrefrence().getLogedIn();
    Future flowStarted = SharedPrefrence().getFlow();

    loginstatus.then((data1) {
      if (data1 == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeTabBar(0)),
        );
      } else {
        flowStarted.then((data2) {
          if (data2 == true && data1 == false) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignIn()),
            );
          } else if (data1 == true && data2 == true) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeTabBar(0)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IntitialScreen()),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/signInBg.jpg"),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween(begin: 0.75, end: 2.0).animate(
                    CurvedAnimation(parent: _controller, curve: Curves.ease)),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset("assets/images/icon.png"),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Center(
                  child: Text(
                "Build your wheel, your future will thank you.",
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenColor),
              ))
            ],
          )),
    );
  }
}
