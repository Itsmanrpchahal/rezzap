import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/PopUps/ColorPopUp.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Screens/TabBarScreens/Resume%20Screens/Templates.dart';

// ignore: must_be_immutable
class DesignResume extends StatefulWidget {
  String reumeId = "";
  String color = "";
  bool editing = false;
  DesignResume(this.reumeId, this.color, this.editing);
  @override
  _DesignResumeState createState() => _DesignResumeState();
}

class _DesignResumeState extends State<DesignResume> {
  Color screenPickerColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    if (widget.editing) {
      setState(() {
        var newColor = widget.color.replaceAll("#", "0x");
        screenPickerColor = Color(int.parse(newColor));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "DESIGN RESUME",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.colorize,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ColorPopUp((value, color) {
                        if (value == true) {
                          setState(() {
                            screenPickerColor = color;
                          });
                        }

                        return value;
                      });
                    });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: TabBar(
                      tabs: [
                        Tab(
                            child: Text(
                          "Option 1",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                        Tab(
                            child: Text(
                          "Option 2",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                        Tab(
                            child: Text(
                          "Option 3",
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                      ],
                      indicatorColor: AppColors.greenColor,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Template(screenPickerColor, "1", widget.reumeId),
                          Template(screenPickerColor, "2", widget.reumeId),
                          Template(screenPickerColor, "3", widget.reumeId),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
