import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

// ignore: camel_case_types
typedef checkValue = bool Function(bool, Color);

// ignore: must_be_immutable
class ColorPopUp extends StatefulWidget {
  checkValue callback;
  ColorPopUp(this.callback);
  @override
  _ColorPopUpState createState() => _ColorPopUpState();
}

class _ColorPopUpState extends State<ColorPopUp> {
  Color screenPickerColor = Colors.white;
  Color dialogPickerColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ValidConstants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 2), blurRadius: 2),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Card(
                    elevation: 2,
                    child: ColorPicker(
                      pickerTypeTextStyle: GoogleFonts.lato(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      color: screenPickerColor,
                      onColorChanged: (Color color) =>
                          setState(() => screenPickerColor = color),
                      width: 30,
                      height: 30,
                      heading: Text('Colors for template',
                          style: GoogleFonts.lato(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      subheading: Text('Color shades',
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey)),
                    ),
                  ),
                ),
              ),
              buttonMenu("Select Color", () {
                widget.callback(true, screenPickerColor);
                Navigator.of(context).pop();
              }, context, Colors.black, 150),
              SizedBox(
                height: 15,
              ),
            ],
          ))
    ]);
  }
}
