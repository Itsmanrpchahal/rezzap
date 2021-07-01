import 'package:flutter/material.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Screens/TabBarScreens/Chat%20Screens/ChatList.dart';
import 'package:rezzap/Screens/TabBarScreens/Dash%20Screens/Dash.dart';
import 'package:rezzap/Screens/TabBarScreens/HomePage.dart';
import 'package:rezzap/Screens/TabBarScreens/Resume%20Screens/MyResume.dart';
import 'package:rezzap/Screens/TabBarScreens/TheSpin.dart';

// ignore: must_be_immutable
class HomeTabBar extends StatefulWidget {
  HomeTabBar(this.selectedIndex);
  var selectedIndex = 0;

  @override
  _MyHomeTabBar createState() => _MyHomeTabBar();
}

class _MyHomeTabBar extends State<HomeTabBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    TheSpin(),
    ChatList(),
    MyResume(),
    Dash()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => !Navigator.of(context).userGestureInProgress,
        child: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/home.png'),
                activeIcon: Image.asset('assets/images/sHome.png'),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/spin.png'),
                activeIcon: Image.asset('assets/images/sSpin.png'),
                label: 'Spin',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/chat.png'),
                activeIcon: Image.asset('assets/images/sChat.png'),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/cv.png'),
                activeIcon: Image.asset('assets/images/sCV.png'),
                label: 'Resume',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/dash.png'),
                activeIcon: Image.asset('assets/images/sDash.png'),
                label: 'Dash',
              ),
            ],
            currentIndex: _selectedIndex,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.greenColor,
            iconSize: 30,
            onTap: _onItemTapped,
          ),
        ));
  }
}
