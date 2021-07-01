import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/UserModel.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:us_states/us_states.dart';
import '../../Models/UserModel.dart';
import '../../Repository/UserRepo.dart';

// ignore: camel_case_types
typedef checkUser = bool Function(bool);

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  checkUser callback;
  UserProfile(this.callback);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // ignore: unused_field
  String _email = "";
  File _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static var selectedDate = DateTime.now();
  var customDate =
      "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
  var accountTypeId = 1;
  var desginationId = 0;
  var genderId = 1;
  var visibleId = 0;
  String userEmail = "";
  List<String> _locations = USStates.getAllNames();
  List<String> accounType = Constant.accountType;
  List<String> designations = Constant.designations;

  TextEditingController birthdayController;
  TextEditingController emailController;
  TextEditingController locationController;
  TextEditingController mobileController;
  TextEditingController genderController;
  TextEditingController addressController;
  TextEditingController streetController;
  TextEditingController zipCodeController;
  TextEditingController visibilityController;
  TextEditingController schoolController;
  TextEditingController collegeController;
  TextEditingController degreeController;
  TextEditingController desginationController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController accountController;

  void initState() {
    super.initState();
    emailController = TextEditingController();
    birthdayController = TextEditingController();
    visibilityController = TextEditingController();
    genderController = TextEditingController();
    locationController = TextEditingController();
    mobileController = TextEditingController();
    addressController = TextEditingController();
    zipCodeController = TextEditingController();
    streetController = TextEditingController();
    schoolController = TextEditingController();
    collegeController = TextEditingController();
    degreeController = TextEditingController();
    desginationController = TextEditingController();
    accountController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      updateUserData(
          firstNameController.text,
          lastNameController.text,
          mobileController.text,
          addressController.text,
          locationController.text,
          birthdayController.text,
          streetController.text,
          genderId.toString(),
          visibleId.toString(),
          schoolController.text,
          collegeController.text,
          degreeController.text,
          desginationId.toString(),
          accountTypeId.toString());
    }
  }

  updateUserData(
      String firstName,
      String lastName,
      String mobile,
      String address,
      String state,
      String dob,
      String street,
      String gender,
      String visibility,
      String highSchool,
      String college,
      String degree,
      String designation,
      String accountType) {
    EasyLoading.show(status: "Updating...");
    UserRepo()
        .updateUser(
            firstName,
            lastName,
            mobile,
            address,
            state,
            dob,
            street,
            gender,
            visibility,
            highSchool,
            college,
            designation,
            degree,
            accountType)
        .then((success) {
      if (_image != null) {
        EasyLoading.show(status: "Updating...");
        UserRepo().uploadProfilePic(_image).then((value) => {
              EasyLoading.showInfo("Updated Successfully"),
              widget.callback(true),
              Navigator.of(context).pop()
            });
      } else {
        EasyLoading.showInfo("Updated Successfully");
        widget.callback(true);
        Navigator.of(context).pop();
      }
    // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((Exception error) => EasyLoading.dismiss());
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 20);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

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
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Profile", true),
        body: SingleChildScrollView(
            child: FutureBuilder<User>(
                future: UserRepo().getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    firstNameController.text = snapshot.data.firstName;
                    lastNameController.text = snapshot.data.lastName;
                    mobileController.text = snapshot.data.mobile;
                    schoolController.text = snapshot.data.highschool;
                    collegeController.text = snapshot.data.college;
                    degreeController.text = snapshot.data.degree;
                    streetController.text = snapshot.data.street;
                    addressController.text = snapshot.data.address;
                    birthdayController.text = snapshot.data.dob;
                    locationController.text = snapshot.data.state;
                    emailController.text = snapshot.data.email;
                    genderController.text = snapshot.data.gender == "3"
                        ? "Other"
                        : snapshot.data.gender == "1"
                            ? "Male"
                            : "Female";
                    var account = int.parse(snapshot.data.accountType);
                    accountController.text = accounType[account - 1];
                    accountTypeId = account;
                    visibilityController.text =
                        snapshot.data.visibility == "0" ? "Public" : "Private";
                    var desgignation = int.parse(snapshot.data.designation);
                    desginationId = desginationId;
                    desginationController.text = designations[desgignation];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Image.asset(
                                  "assets/images/roundBg.png",
                                  fit: BoxFit.cover,
                                  width: 250,
                                  height: 250,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 43, left: 43),
                                  child: CircleAvatar(
                                    backgroundImage: _image == null
                                        ? NetworkImage(
                                            (snapshot.data.profilePhoto == null)
                                                ? Constant.placeHolderImage
                                                : Constant.imageUrl +
                                                    snapshot.data.profilePhoto)
                                        : FileImage(_image),
                                    radius: 82,
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 190, top: 160),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 2.0,
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                    ),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                        margin: EdgeInsets.all(2),
                                        child: IconButton(
                                          iconSize: 30,
                                          icon: Image.asset(
                                              "assets/images/camera.png"),
                                          onPressed: () {
                                            _showPicker(context);
                                          },
                                        ))),
                              ],
                            )),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.person)),
                                      Text(
                                        "   First Name :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                controller: firstNameController,
                                                cursorColor: Colors.black,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                validator: (val) => val.isEmpty
                                                    ? 'Please enter first name.'
                                                    : null,
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.person_pin)),
                                      Text(
                                        "   Last Name :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                controller: lastNameController,
                                                cursorColor: Colors.black,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                validator: (val) => val.isEmpty
                                                    ? 'Please enter Second name.'
                                                    : null,
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.account_box)),
                                      Text(
                                        "   Account type :",
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 3.5),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: accountController,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                  suffixIcon:
                                                      PopupMenuButton<String>(
                                                    icon: const Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                    onSelected: (String value) {
                                                      var index = accounType
                                                          .indexWhere((note) =>
                                                              note.startsWith(
                                                                  value));
                                                      accountTypeId = index + 1;
                                                      accountController.text =
                                                          value;
                                                    },
                                                    itemBuilder:
                                                        (BuildContext context) {
                                                      return accounType.map<
                                                              PopupMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return new PopupMenuItem(
                                                            child:
                                                                new Text(value),
                                                            value: value);
                                                      }).toList();
                                                    },
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.grey[200],
                                  height: 50,
                                  margin: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child:
                                              Icon(Icons.location_searching)),
                                      Text(
                                        "   Location :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 3.5),
                                              child: TextFormField(
                                                  readOnly: true,
                                                  controller:
                                                      locationController,
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                      suffixIcon:
                                                          PopupMenuButton<
                                                              String>(
                                                        icon: const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black,
                                                          size: 30,
                                                        ),
                                                        onSelected:
                                                            (String value) {
                                                          locationController
                                                              .text = value;
                                                        },
                                                        itemBuilder:
                                                            (BuildContext
                                                                context) {
                                                          return _locations.map<
                                                                  PopupMenuItem<
                                                                      String>>(
                                                              (String value) {
                                                            return new PopupMenuItem(
                                                                child: new Text(
                                                                    value),
                                                                value: value);
                                                          }).toList();
                                                        },
                                                      ),
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'Not Available'))))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child:
                                              Icon(Icons.calendar_today_sharp)),
                                      Text(
                                        "   DOB :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                onTap: () {
                                                  showDatePicker(
                                                      context: context,
                                                      initialDate: selectedDate,
                                                      firstDate:
                                                          DateTime(1970, 1),
                                                      lastDate: selectedDate,
                                                      builder:
                                                          (BuildContext context,
                                                              Widget picker) {
                                                        return Theme(
                                                          data: ThemeData.dark()
                                                              .copyWith(
                                                            colorScheme:
                                                                ColorScheme
                                                                    .light(
                                                              primary:
                                                                  Colors.blue,
                                                              onPrimary:
                                                                  Colors.white,
                                                              surface:
                                                                  Colors.white,
                                                              onSurface:
                                                                  Colors.black,
                                                            ),
                                                            dialogBackgroundColor:
                                                                Colors.white,
                                                          ),
                                                          child: picker,
                                                        );
                                                      }).then((selectedDate) {
                                                    if (selectedDate != null) {
                                                      customDate =
                                                          "${selectedDate.year.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                                      birthdayController.text =
                                                          customDate;
                                                    }
                                                  });
                                                },
                                                controller: birthdayController,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Not Available'),
                                                readOnly: true,
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(
                                              Icons.verified_user_rounded)),
                                      Text(
                                        "   Gender :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 3.5),
                                              child: TextFormField(
                                                controller: genderController,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    suffixIcon:
                                                        PopupMenuButton<String>(
                                                      icon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.black,
                                                        size: 30,
                                                      ),
                                                      onSelected:
                                                          (String value) {
                                                        genderController.text =
                                                            value;
                                                        if (value == "Male") {
                                                          genderId = 1;
                                                        } 
                                                        else if(value == "Female"){
                                                          genderId = 2;
                                                        }
                                                        else {
                                                          genderId = 3;
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext
                                                          context) {
                                                        return Constant.gender.map<
                                                                PopupMenuItem<
                                                                    String>>(
                                                            (String value) {
                                                          return new PopupMenuItem(
                                                              child: new Text(
                                                                  value),
                                                              value: value);
                                                        }).toList();
                                                      },
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText:
                                                      (snapshot.data.gender ==
                                                                "3") ? "Other" : (snapshot.data.gender ==
                                                                "1")
                                                            ? "Male"
                                                            : "Female"),
                                                readOnly: true,
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.phone)),
                                      Text(
                                        "   Mobile :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                controller: mobileController,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Not Available'),
                                                validator: (val) => val
                                                            .length !=
                                                        10
                                                    ? 'Mobile number must be of 10 digit'
                                                    : null,
                                                keyboardType:
                                                    TextInputType.phone,
                                                textInputAction:
                                                    TextInputAction.next,
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.mail)),
                                      Text(
                                        "   Email :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                controller: emailController,
                                                readOnly: true,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Not Avialable"),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.apps)),
                                      Text(
                                        "   Rezzap :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                readOnly: true,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        snapshot.data.rezzapId),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.business)),
                                      Text(
                                        "   High School :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                controller: schoolController,
                                                cursorColor: Colors.black,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Not Available'),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.school_sharp)),
                                      Text(
                                        "   College :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                controller: collegeController,
                                                cursorColor: Colors.black,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Not Available'),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.pages_sharp)),
                                      Text(
                                        "   Degree :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                controller: degreeController,
                                                cursorColor: Colors.black,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Not Available'),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.work)),
                                      Text(
                                        "   Designation :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 3.5),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller:
                                                    desginationController,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    suffixIcon:
                                                        PopupMenuButton<String>(
                                                      icon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.black,
                                                        size: 30,
                                                      ),
                                                      onSelected:
                                                          (String value) {
                                                        var index = designations
                                                            .indexWhere(
                                                                (note) => note
                                                                    .startsWith(
                                                                        value));
                                                        desginationId = index;
                                                        desginationController
                                                            .text = value;
                                                      },
                                                      itemBuilder: (BuildContext
                                                          context) {
                                                        return designations.map<
                                                                PopupMenuItem<
                                                                    String>>(
                                                            (String value) {
                                                          return new PopupMenuItem(
                                                              child: new Text(
                                                                  value),
                                                              value: value);
                                                        }).toList();
                                                      },
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: 'Not Available'),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.home)),
                                      Text(
                                        "   Address :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: TextFormField(
                                                controller: addressController,
                                                cursorColor: Colors.black,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Not Available'),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.add_road_sharp)),
                                      Text(
                                        "   Sreet :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: TextFormField(
                                                controller: streetController,
                                                cursorColor: Colors.black,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Not Available'),
                                              )))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.visibility)),
                                      Text(
                                        "   Visibily :",
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                      Expanded(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 3.5),
                                              child: TextFormField(
                                                controller:
                                                    visibilityController,
                                                readOnly: true,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    suffixIcon:
                                                        PopupMenuButton<String>(
                                                      icon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.black,
                                                        size: 30,
                                                      ),
                                                      onSelected:
                                                          (String value) {
                                                        visibilityController
                                                            .text = value;
                                                        if (value == "Public") {
                                                          visibleId = 0;
                                                        } else {
                                                          visibleId = 1;
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext
                                                          context) {
                                                        return Constant.visibily
                                                            .map<
                                                                    PopupMenuItem<
                                                                        String>>(
                                                                (String value) {
                                                          return new PopupMenuItem(
                                                              child: new Text(
                                                                  value),
                                                              value: value);
                                                        }).toList();
                                                      },
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: (snapshot.data
                                                                .visibility ==
                                                            "1")
                                                        ? "Private"
                                                        : "Public"),
                                              )))
                                    ],
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        buttonMenu("Save Profile", () {
                          validateAndSave();
                        }, context, Colors.black,
                            MediaQuery.of(context).size.width / 2),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  } else {
                    EasyLoading.show();
                    return Text("");
                  }
                })));
  }
}
