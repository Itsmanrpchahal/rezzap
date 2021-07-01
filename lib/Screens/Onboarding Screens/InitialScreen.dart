import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/CommonPrefrence.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/SignIn.dart';

class IntitialScreen extends StatefulWidget {
  @override
  _IntitialScreenState createState() => _IntitialScreenState();
}

class _IntitialScreenState extends State<IntitialScreen> {
  var titleText = "Why blend it when you can stand out";
  var isButtonVisible = false;
  var assetsImage = "assets/images/initial1.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/initialBg.png"),
            fit: BoxFit.cover,
          )),
          child: Column(children: [
            Expanded(
                child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return new Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    assetsImage,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    height: 20,
                    child: Text(
                      titleText,
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ]);
              },
              itemCount: 3,
              autoplay: true,
              pagination: new SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.grey, activeColor: Colors.white),
              ),
              onIndexChanged: (index) {
                setState(() {
                  switch (index) {
                    case 0:
                      titleText = "Why blend in when you can stand out";
                      assetsImage = "assets/images/initial1.png";
                      break;
                    case 1:
                      titleText = "Make your life story worth telling";
                      assetsImage = "assets/images/initial2.png";
                      break;
                    case 2:
                      titleText = "See your resume come to life";
                      assetsImage = "assets/images/initial3.png";
                      break;

                      break;
                    default:
                  }
                });
              },
            )),
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(children: [
                  TextButton(
                      onPressed: () {
                        SharedPrefrence().setFlow(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Text(
                        "Start",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )),
                ]))
          ]))),
    );
  }
}
