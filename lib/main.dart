import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/InitialScreen.dart';
import 'package:rezzap/Screens/Onboarding%20Screens/SignIn.dart';
import 'package:rezzap/Screens/TabBarScreens/HomeTabBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final flowStarted = prefs.getBool(KeyConstants.flowStarted) ?? false;
  final userLoggedIn = prefs.getBool(KeyConstants.userLoggedIn) ?? false;
  runApp(MaterialApp(
    builder: EasyLoading.init(),
    debugShowCheckedModeBanner: false,
    home: (flowStarted && userLoggedIn)
        ? HomeTabBar(0)
        : (flowStarted)
            ? SignIn()
            : IntitialScreen(),
  ));
}
