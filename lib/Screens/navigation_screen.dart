import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Screens/account_screen.dart';
import 'package:vardrobe/Screens/cart_screen.dart';
import 'package:vardrobe/Screens/ar_vr_screen.dart';
import 'package:vardrobe/Screens/home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:io';

import 'package:vardrobe/Widgets/constants.dart';

class navigation_screen extends StatefulWidget {
  @override
  _navigation_screenState createState() => _navigation_screenState();
}

class _navigation_screenState extends State<navigation_screen> {
  final List<Widget> _children=[home_screen(),ar_vr_screen(),cart_Screen(),account_screen()];
  int _position=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_children[_position],
      bottomNavigationBar:CurvedNavigationBar(
        color: const Color(0xff1E1F28),
        buttonBackgroundColor: const Color(0xffEF3651),
        backgroundColor: const Color(0xff623B47),
        animationCurve: Curves.easeInOutQuart,
        animationDuration: const Duration(milliseconds: 600),
        index: _position,
          items:<Widget>[
            Padding(padding:const EdgeInsets.only(top: 20.0),child: Column(children:<Widget>[
              Icon(Platform.isAndroid?FontAwesomeIcons.home:CupertinoIcons.house,color: Colors.white,),
              Text('Home',style: TextStyle(fontFamily: kfontfamily),)],)),
            Padding(padding:const EdgeInsets.only(top: 20.0),child: Column(children:<Widget>[
              Icon(Platform.isAndroid?FontAwesomeIcons.eye:CupertinoIcons.eye),
              Text('AR/VR',style: TextStyle(fontFamily: kfontfamily),)],)),
            Padding(padding:const EdgeInsets.only(top: 20.0),child: Column(children:<Widget>[
              Icon(Platform.isAndroid?FontAwesomeIcons.shoppingBag:CupertinoIcons.cart,),
              Text('Cart',style: TextStyle(fontFamily: kfontfamily),)],)),
            Padding(padding:const EdgeInsets.only(top: 20.0),child: Column(children:<Widget>[
              Icon(Platform.isAndroid?FontAwesomeIcons.userAstronaut:CupertinoIcons.person),
              Text('Account',style: TextStyle(fontFamily: kfontfamily),)],)),
      ],
      onTap: (value){
            setState(() {
              _position=value;
            });
      },
      ),
      );
  }
}
