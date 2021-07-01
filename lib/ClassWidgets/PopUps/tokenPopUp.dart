import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

// ignore: must_be_immutable
class TokenPopUp extends StatefulWidget {
  bool isForEmail = false;
  TokenPopUp(this.isForEmail);
  @override
  _TokenPopUpState createState() => _TokenPopUpState();
}

class _TokenPopUpState extends State<TokenPopUp> {
  TextEditingController inputController;

  void initState() {
    super.initState();
    inputController = TextEditingController();
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
    return Stack(
      children: <Widget>[
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
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                      child: Text(
                          (widget.isForEmail)
                              ? "Enter email to share link of your scores"
                              : "Unlimited Category Access Code",
                          style: GoogleFonts.lato(fontSize: 18)))),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: TextFormField(
                    controller: inputController,
                    decoration: new InputDecoration(
                      labelText: (widget.isForEmail) ? "Email" : "Access code",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              buttonMenu((widget.isForEmail) ? "Share" : "Send", () {
                if (inputController.text != "") {
                  if (widget.isForEmail) {
                  } else {}
                } else {
                  EasyLoading.showError("Please fille required details");
                }
              }, context, AppColors.greenColor, 100),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
