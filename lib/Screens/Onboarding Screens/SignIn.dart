import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/PopUps/VerifyPopUp.dart';
import 'package:rezzap/Common+Store/CommonPrefrence.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/UserModel.dart';
import 'package:rezzap/Repository/UserRepo.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/ForgotPassword.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/SignUp.dart';
import 'package:rezzap/Screens/TabBarScreens/HomeTabBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  TextEditingController emailController;
  TextEditingController passwordController;
  UserRepo userRepository = UserRepo();
  bool showvalue = false;

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      doLogin(emailController.text, passwordController.text);
    }
  }

  doLogin(String username, String password) {
    EasyLoading.show(status: "Loggin in...");
    userRepository.login(username, password).then((User user) {
      EasyLoading.dismiss();
      Future isEmailVerified = SharedPrefrence().getEmailVerified();
      isEmailVerified.then((data1) {
        if (data1 == true) {
          SharedPrefrence().setLoggedIn(true);
          if (showvalue) {
            SharedPrefrence().setEmail(username.toString());
            SharedPrefrence().setPassword(password.toString());
          } else {
            removeKeys();
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeTabBar(0)),
          );
        } else {
          EasyLoading.dismiss();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return VerifyEmailPopUp(false);
              });
        }
      });
      // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((Exception error) => print(error));
  }

  void removeKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(KeyConstants.email);
    prefs.remove(KeyConstants.password);
  }

  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    getDefaultData();
  }

  void getDefaultData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final pass = prefs.getString(KeyConstants.password) ?? '';
    final email = prefs.getString(KeyConstants.email) ?? '';
    print(pass);
    print(email);
    if (pass != null) {
      setState(() {
        emailController.text = email;
        passwordController.text = pass;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var center = new Center(
      child: Text(
        "Sign In",
        style: GoogleFonts.lato(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
    return WillPopScope(
        onWillPop: () async => !Navigator.of(context).userGestureInProgress,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/signInBg.jpg"),
              fit: BoxFit.cover,
            )),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      "Login",
                      style: GoogleFonts.lato(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Email",
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 10),
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
                                validator: (value) =>
                                    ValidConstants.isEmail(value)
                                        ? null
                                        : "Please enter vaild email",
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Password",
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: TextFormField(
                                controller: passwordController,
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText
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
                                obscureText: _obscureText,
                              )),
                          Container(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password ?",
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ))),
                          Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                activeColor: Colors.black,
                                value: this.showvalue,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.showvalue = value;
                                  });
                                },
                              ),
                              Text(
                                "Remember me",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          )),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: RawMaterialButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  fillColor: Colors.black,
                                  child: new Container(
                                    height: 50.0,
                                    width: 200,
                                    child: center,
                                  ),
                                  onPressed: () {
                                    validateAndSave();
                                  })),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account ?",
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()),
                                      );
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
