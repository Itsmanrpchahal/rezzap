import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/PopUps/VerifyPopUp.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/CommonPrefrence.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/UserModel.dart';
import 'package:rezzap/Repository/UserRepo.dart';
import 'package:rezzap/Screens/TabBarScreens/HomeTabBar.dart';
import 'package:us_states/us_states.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String radioButtonItem = '';
  int genderId = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController birthdayController;
  TextEditingController stateController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController mobileController;
  TextEditingController conformPassController;
  TextEditingController rezzappIdController;
  TextEditingController acountController;
  TextEditingController addressController;
  TextEditingController cityController;
  TextEditingController streetController;
  TextEditingController zipCodeController;
  static var selectedDate = DateTime.now();
  var customDate =
      "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
  // ignore: unused_field
  List<String> _locations = USStates.getAllNames();
  List<String> accounType = Constant.accountType;
  UserRepo userRepository = UserRepo();
  var accountTypeId = 1;

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      if (radioButtonItem == '') {
        EasyLoading.showError("Please select gender");
      } else if (passwordController.text != conformPassController.text) {
        EasyLoading.showError("Password did not match");
      } else {
        doSignup(
            firstNameController.text,
            passwordController.text,
            emailController.text,
            lastNameController.text,
            mobileController.text,
            accountTypeId,
            addressController.text,
            cityController.text,
            stateController.text,
            zipCodeController.text,
            birthdayController.text,
            streetController.text,
            genderId,
            rezzappIdController.text);
      }
    } else {
      EasyLoading.showError("Fill all required details");
    }
  }

  doSignup(
      String firstName,
      String password,
      String email,
      String lastName,
      String mobile,
      int accountType,
      String address,
      String city,
      String state,
      String zip,
      String dob,
      String street,
      int gender,
      String rezzapId) {
    EasyLoading.show(status: "Signing up...");
    userRepository
        .signUp(
            email,
            password,
            rezzapId,
            firstName,
            lastName,
            mobile,
            accountType.toString(),
            address,
            city,
            state,
            zip,
            dob,
            street,
            gender.toString())
        .then((User user) {
      EasyLoading.dismiss();
      Future isEmailVerified = SharedPrefrence().getEmailVerified();
      isEmailVerified.then((data1) {
        print("my data $data1");
        if (data1 == true) {
          SharedPrefrence().setLoggedIn(true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeTabBar(0)),
          );
        } else {
          EasyLoading.dismiss();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return VerifyEmailPopUp(true);
              });
        }
      });
    // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((Exception error) => EasyLoading.dismiss());
  }

  void initState() {
    super.initState();
    birthdayController = TextEditingController();
    passwordController = TextEditingController();
    conformPassController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    rezzappIdController = TextEditingController();
    acountController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    zipCodeController = TextEditingController();
    streetController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/signInBg.jpg"),
              fit: BoxFit.cover,
            )),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 50),
                        alignment: Alignment.center,
                        child: Text(
                          "Create your account",
                          style: GoogleFonts.lato(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        )),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 30),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "First Name",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                controller: firstNameController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    hintText: 'Fisrt Name',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                textInputAction: TextInputAction.next,
                                validator: (val) => val.isEmpty
                                    ? 'Please enter first name.'
                                    : null,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Last Name",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                controller: lastNameController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                textInputAction: TextInputAction.next,
                                validator: (val) => val.isEmpty
                                    ? 'Please enter last name.'
                                    : null,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Email",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                controller: emailController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) =>
                                    ValidConstants.isEmail(value)
                                        ? null
                                        : "Please enter vaild email.",
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Rezzapp User Id",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                controller: rezzappIdController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    hintText: 'Rezzapp User Id',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                textInputAction: TextInputAction.next,
                                validator: (val) => val.length < 4
                                    ? 'Rezzap Id is too short.'
                                    : null,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Password",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                controller: passwordController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText1 = !_obscureText1;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText1
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black,
                                        )),
                                    hintText: 'Password',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                validator: (val) => val.length < 6
                                    ? 'Password too short.'
                                    : null,
                                obscureText: _obscureText1,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Confirm Password",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                controller: conformPassController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                textInputAction: TextInputAction.next,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText2 = !_obscureText2;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText2
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black,
                                        )),
                                    hintText: 'Password',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                validator: (val) => val.length < 6
                                    ? 'Password too short.'
                                    : null,
                                obscureText: _obscureText2,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Mobile",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                controller: mobileController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    hintText: 'Mobile ',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                keyboardType: TextInputType.phone,
                                validator: (val) => val.length != 10
                                    ? 'Mobile number must be of 10 digits'
                                    : null,
                              )),

                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Birthday",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                readOnly: true,
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(1950, 1),
                                      lastDate: selectedDate,
                                      builder: (BuildContext context,
                                          Widget picker) {
                                        return Theme(
                                          data: ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: AppColors.primaryColor,
                                            ),
                                            buttonTheme: ButtonThemeData(
                                                textTheme: ButtonTextTheme
                                                    .accent //color of the text in the button "OK/CANCEL"
                                                ),
                                            dialogBackgroundColor:
                                                Colors.blue[300],
                                          ),
                                          child: picker,
                                        );
                                      }).then((selectedDate) {
                                    if (selectedDate != null) {
                                      customDate =
                                          "${selectedDate.year.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

                                      birthdayController.text = customDate;
                                    }
                                  });
                                },
                                controller: birthdayController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    hintText: 'Birthday',
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.grey)),
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                validator: (val) => val.isEmpty
                                    ? 'Please enter birthday'
                                    : null,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Account Type",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              child: TextFormField(
                                readOnly: true,
                                controller: acountController,
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    suffixIcon: PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      onSelected: (String value) {
                                        var index = accounType.indexWhere(
                                            (note) => note.startsWith(value));
                                        accountTypeId = index + 1;
                                        acountController.text = value;
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return accounType
                                            .map<PopupMenuItem<String>>(
                                                (String value) {
                                          return new PopupMenuItem(
                                              child: new Text(value),
                                              value: value);
                                        }).toList();
                                      },
                                    ),
                                    hintText: 'Account Type',
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black))),
                                validator: (val) => val.isEmpty
                                    ? 'Please select account type.'
                                    : null,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Gender",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Radio(
                                      value: 1,
                                      groupValue: genderId,
                                      onChanged: (val) {
                                        setState(() {
                                          radioButtonItem = 'Male';
                                          genderId = 1;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Male',
                                      style: new TextStyle(fontSize: 17.0),
                                    ),
                                    Radio(
                                      value: 2,
                                      groupValue: genderId,
                                      onChanged: (val) {
                                        setState(() {
                                          radioButtonItem = 'Female';
                                          genderId = 2;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Female',
                                      style: new TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    Radio(
                                      value: 3,
                                      groupValue: genderId,
                                      onChanged: (val) {
                                        setState(() {
                                          radioButtonItem = 'Other';
                                          genderId = 3;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Other',
                                      style: new TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ])),
                          // Container(
                          //     margin: EdgeInsets.only(left: 40, top: 15),
                          //     alignment: Alignment.topLeft,
                          //     child: Text(
                          //       "Address",
                          //       style: GoogleFonts.lato(
                          //           fontSize: 16,
                          //           color: Colors.black,
                          //           fontWeight: FontWeight.w600),
                          //     )),
                          // Container(
                          //     margin: EdgeInsets.only(left: 40, right: 40),
                          //     child: ConstrainedBox(
                          //         constraints: BoxConstraints(
                          //           maxHeight: 50.0,
                          //         ),
                          //         child: TextFormField(
                          //           controller: addressController,
                          //           maxLines: null,
                          //           style: GoogleFonts.lato(
                          //               fontSize: 18,
                          //               color: Colors.black,
                          //               fontWeight: FontWeight.w500),
                          //           cursorColor: Colors.black,
                          //           decoration: InputDecoration(
                          //               hintText: 'Address',
                          //               focusedBorder: new UnderlineInputBorder(
                          //                   borderSide:
                          //                       new BorderSide(color: Colors.black))),
                          //           textInputAction: TextInputAction.next,
                          //         ))),
                          // Container(
                          //     margin: EdgeInsets.only(left: 40, right: 40),
                          //     child: TextFormField(
                          //       controller: streetController,
                          //       maxLines: null,
                          //       style: GoogleFonts.lato(
                          //           fontSize: 18,
                          //           color: Colors.black,
                          //           fontWeight: FontWeight.w500),
                          //       cursorColor: Colors.black,
                          //       decoration: InputDecoration(
                          //           hintText: 'Street',
                          //           focusedBorder: new UnderlineInputBorder(
                          //               borderSide:
                          //                   new BorderSide(color: Colors.black))),
                          //       textInputAction: TextInputAction.next,
                          //     )),
                          // Container(
                          //     margin: EdgeInsets.only(left: 40, right: 40),
                          //     child: TextFormField(
                          //       controller: cityController,
                          //       maxLines: null,
                          //       style: GoogleFonts.lato(
                          //           fontSize: 18,
                          //           color: Colors.black,
                          //           fontWeight: FontWeight.w500),
                          //       cursorColor: Colors.black,
                          //       decoration: InputDecoration(
                          //           hintText: 'City',
                          //           focusedBorder: new UnderlineInputBorder(
                          //               borderSide:
                          //                   new BorderSide(color: Colors.black))),
                          //     )),
                          // Container(
                          //     margin: EdgeInsets.only(left: 40, right: 40),
                          //     child: TextFormField(
                          //       readOnly: true,
                          //       controller: stateController,
                          //       maxLines: null,
                          //       style: GoogleFonts.lato(
                          //           fontSize: 18,
                          //           color: Colors.black,
                          //           fontWeight: FontWeight.w500),
                          //       cursorColor: Colors.black,
                          //       decoration: InputDecoration(
                          //           suffixIcon: PopupMenuButton<String>(
                          //             icon: const Icon(
                          //               Icons.arrow_drop_down,
                          //               color: Colors.black,
                          //               size: 30,
                          //             ),
                          //             onSelected: (String value) {
                          //               stateController.text = value;
                          //             },
                          //             itemBuilder: (BuildContext context) {
                          //               return _locations.map<PopupMenuItem<String>>(
                          //                   (String value) {
                          //                 return new PopupMenuItem(
                          //                     child: new Text(value), value: value);
                          //               }).toList();
                          //             },
                          //           ),
                          //           hintText: 'State',
                          //           focusedBorder: new UnderlineInputBorder(
                          //               borderSide:
                          //                   new BorderSide(color: Colors.black))),
                          //     )),
                          // Container(
                          //     margin: EdgeInsets.only(left: 40, right: 40),
                          //     child: TextFormField(
                          //       controller: zipCodeController,
                          //       maxLines: null,
                          //       style: GoogleFonts.lato(
                          //           fontSize: 18,
                          //           color: Colors.black,
                          //           fontWeight: FontWeight.w500),
                          //       cursorColor: Colors.black,
                          //       decoration: InputDecoration(
                          //           hintText: 'Zip Code',
                          //           focusedBorder: new UnderlineInputBorder(
                          //               borderSide:
                          //                   new BorderSide(color: Colors.black))),
                          //     )),
                          Container(
                              margin: EdgeInsets.only(top: 30),
                              child: RawMaterialButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  fillColor: Colors.black,
                                  child: new Container(
                                    height: 60.0,
                                    width: 230,
                                    child: new Center(
                                      child: Text(
                                        "Create Account",
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    validateAndSave();
                                  })),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      )),
                    )
                  ],
                )),
          )),
    );
  }
}
