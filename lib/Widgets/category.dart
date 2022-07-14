import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:vardrobe/Screens/category_display_screen.dart';

import 'constants.dart';

class category extends StatelessWidget {
   final String categoryname;
   final String categorypath;

  const category({this.categoryname, this.categorypath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
            },
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
              return category_display_screen(cat:categoryname,);
            }
        ));
      },
      child: Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff2A2C36),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget> [
              Text("$categoryname",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
              Container(
                width: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8.0),bottomRight:Radius.circular(8.0)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("$categorypath")
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}