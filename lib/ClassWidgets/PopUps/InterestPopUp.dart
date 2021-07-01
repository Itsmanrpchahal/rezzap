import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';
import 'package:rezzap/Repository/InterestRepo.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';

// ignore: camel_case_types
typedef checkValue = bool Function(bool);

// ignore: must_be_immutable
class InterestPopUp extends StatefulWidget {
  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
  checkValue callback;
  InterestPopUp(this.callback, this.isEditing, this.name, this.url,
      this.imageUrl, this.id);
  bool isEditing = false;
  String name = "";
  String url = "";
  String imageUrl = "";
  String id = "";
}

class _CustomDialogBoxState extends State<InterestPopUp> {
  File _image;
  var interestId = "";
  TextEditingController titleController;
  TextEditingController urlController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String imageSelected = "";
  bool isLoadingImage = true;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 2);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        imageSelected = "1";
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      imageSelected = "1";
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    urlController = TextEditingController();
    if (widget.isEditing) {
      setData();
    }
  }

  void setData() {
    EasyLoading.show();
    titleController.text = widget.name;
    urlController.text = widget.url;
    interestId = widget.id;
    imageSelected = "0";
    if (widget.imageUrl == "") {
      isLoadingImage = false;
      EasyLoading.dismiss();
    } else {
      urlToFile(widget.imageUrl).then((value) => {
            EasyLoading.dismiss(),
            setState(() {
              _image = value;
              isLoadingImage = false;
            })
          });
    }
  }

  void validateAndSaveAdd() {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (_image == null) {
        addNoImageInterest();
      } else {
        addInterest();
      }
    } else {
      EasyLoading.showError("Fill all required details");
    }
  }

  void validateAndSaveEdit() {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      if (_image == null) {
        editNoImageInterest();
      } else {
        editInterest();
      }
    } else {
      EasyLoading.showError("Fill all required details");
    }
  }

  void addInterest() async {
    EasyLoading.show();
    InterestRepo()
        .addInterest(titleController.text, urlController.text, _image)
        .then((value) => {
              widget.callback(true),
              EasyLoading.showInfo("Interest Added Successfully"),
              Navigator.of(context).pop()
            });
    ;
  }

  void addNoImageInterest() async {
    EasyLoading.show();
    InterestRepo()
        .addNoImageInterest(titleController.text, urlController.text)
        .then((value) => {
              widget.callback(true),
              EasyLoading.showInfo("Interest Added Successfully"),
              Navigator.of(context).pop()
            });
  }

  void editInterest() async {
    EasyLoading.show();
    InterestRepo()
        .editInterest(interestId, titleController.text, urlController.text,
            _image, imageSelected)
        .then((value) => {
              widget.callback(true),
              EasyLoading.showInfo("Interest updated Successfully"),
              Navigator.of(context).pop()
            });
  }

  void editNoImageInterest() async {
    EasyLoading.show();
    InterestRepo()
        .editNoImageInterest(
            interestId, titleController.text, urlController.text, imageSelected)
        .then((value) => {
              widget.callback(true),
              EasyLoading.showInfo("Interest updated Successfully"),
              Navigator.of(context).pop()
            });
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
    return SingleChildScrollView(
        child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(ValidConstants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 2), blurRadius: 5),
              ]),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text("ADD INTEREST", style: GoogleFonts.lato(fontSize: 18)),
                  Container(
                    height: 1,
                    color: AppColors.greyColor,
                    margin: EdgeInsets.only(top: 10),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: titleController,
                        decoration: new InputDecoration(
                          labelText: "Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Name cannot be empty";
                          } else {
                            return null;
                          }
                        },
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: urlController,
                        decoration: new InputDecoration(
                          labelText: "URL (http://abc.com)",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (value) => ValidConstants.isUrl(value)
                            ? null
                            : "Please enter vaild url.",
                      )),
                  InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: _image == null
                            ? (!widget.isEditing || widget.imageUrl == "")
                                ? Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    margin: EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(
                                      "Add Image",
                                      style: GoogleFonts.lato(fontSize: 18),
                                    )),
                                  )
                                : Image.network(widget.imageUrl)
                            : Image.file(
                                (File(_image.path)),
                              ),
                      )),
                  (!widget.isEditing)
                      ? Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: buttonMenu("Add Interest", () {
                            validateAndSaveAdd();
                          }, context, Colors.black, double.infinity))
                      : Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: buttonMenu("Edit Interest", () {
                            !isLoadingImage
                                ? validateAndSaveEdit()
                                : EasyLoading.show(status: "Please wait...");
                          }, context, Colors.black, double.infinity)),
                  SizedBox(
                    height: 15,
                  )
                ],
              )),
        ),
      ],
    ));
  }
}
