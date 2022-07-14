import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:vardrobe/Screens/navigation_screen.dart';
import 'package:vardrobe/Widgets/constants.dart';

class success_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 31, 40, 0.7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: Column(
              children:<Widget> [
                Image.asset("Assets/images/success.png",
                  height:200.0 ,
                  width: 200.0,
                ),
                Text("Success!",style: TextStyle(fontFamily: kfontfamily,fontSize: 30.0),),
                Text("Your order will be delivered soon.",style: TextStyle(fontFamily: kfontfamily,fontSize: 16.0),),
                Text("Thankyou for choosing our app",style: TextStyle(fontFamily: kfontfamily,fontSize: 16.0),),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:25.0 ,right: 25.0,bottom: 10.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ]
              ),
              height: 40.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  primary: Color(0xffEF3651),
                ),
                onPressed: (){
                  Navigator.push(context, PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                        return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                      },
                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                        return navigation_screen();
                      }
                  ));
                },
                child: Text('CONTINUE SHOPPING',style: TextStyle(fontSize: 20.0,fontFamily: kfontfamily),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
