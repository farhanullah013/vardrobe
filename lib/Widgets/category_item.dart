import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:vardrobe/Screens/category_display_screen.dart';
import 'package:vardrobe/Screens/category_screen.dart';

import 'constants.dart';

class category_item extends StatelessWidget {
  final String image_path;
  final String text;

  category_item({this.image_path, this.text});

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
              return category_display_screen(cat: text,);
            }
        ));
      },
      child: Container(
        child: Column(
          children:<Widget>[
            Expanded(
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.1),
                radius: 30,
                child: ClipOval(
                    child: Image.asset(image_path)
                ),
              ),
            ),
            SizedBox(height:4.0),
            Text(text,style: TextStyle(fontSize: 14.0,fontFamily: kfontfamily),),
          ],
        ),
      ),
    );
  }
}