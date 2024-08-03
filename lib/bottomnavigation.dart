import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/privacypolicy.dart';
import 'package:kids/setting.dart';
import 'package:kids/homeScreen.dart';
import 'homeScreen.dart';

class BottomNav extends StatefulWidget{
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 1;

  static List<Widget> _pages = <Widget>[
    Setting(),
    HomeScreen(),
    PrivacyPolicy(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
     bottomNavigationBar: BottomNavigationBar(
       iconSize: 32,
       selectedItemColor: Color(0xFFF19335),
       selectedIconTheme: IconThemeData(color: Color(0xFFF19335)),
       currentIndex: _selectedIndex, //New
       onTap: _onItemTapped,
       items: const <BottomNavigationBarItem>[
         BottomNavigationBarItem(
           icon: ImageIcon(AssetImage("assets/images/12Icon feather-settings.png")),
           label: 'Setting',
         ),
         BottomNavigationBarItem(
           icon: ImageIcon(AssetImage("assets/images/12Group 1.png")),
           label: 'Home',
         ),
         BottomNavigationBarItem(
           icon: ImageIcon(AssetImage("assets/images/privacy.png")),
           label: 'Privacy',
         ),
       ],
     ),
     body: Center(
       child: _pages.elementAt(_selectedIndex),

     ),

   );
  }
}