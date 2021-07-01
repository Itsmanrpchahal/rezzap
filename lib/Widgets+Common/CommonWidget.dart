import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(this.barTitle, this.isBackButton, {Key key})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);
  var barTitle = "";
  var isBackButton = false;
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2.0,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Text(
        barTitle,
        style: TextStyle(color: Colors.black),
      ),
      automaticallyImplyLeading: isBackButton,
      actions: <Widget>[],
      backgroundColor: Colors.white,
    );
  }
}

// ignore: must_be_immutable

RawMaterialButton buttonMenu(String title, GestureTapCallback onPressed,
    BuildContext context, Color color, double size) {
  return new RawMaterialButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0)),
      fillColor: color,
      child: new Container(
        height: 40.0,
        width: size,
        child: new Center(
          child: Text(
            title,
            style: GoogleFonts.lato(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      onPressed: onPressed);
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final bool isStart;

  const Indicator({
    Key key,
    this.color,
    this.isStart,
    this.text,
    this.isSquare,
    this.size = 20,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isStart ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Flexible(
            child: Container(
                child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        )))
      ],
    );
  }
}
