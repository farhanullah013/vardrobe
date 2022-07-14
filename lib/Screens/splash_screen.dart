import 'package:flutter/material.dart';
import 'package:vardrobe/Screens/navigation_screen.dart';
import 'package:vardrobe/Services/splash_animation.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:vardrobe/Widgets/constants.dart';

class splash_screen extends StatefulWidget {
  @override
  _splash_screenState createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {

    super.initState();
    _controller=AnimationController(
      duration: Duration(seconds: 5),
      vsync:this,
    );
    _animation=CurvedAnimation(parent: _controller,curve:Curves.easeInOutQuint);
    _controller.forward();
    _animation.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        Navigator.push(context, PageRouteBuilder(
            transitionDuration: const Duration(seconds: 2),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
            },
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
              return navigation_screen();
            }
        ));
      }
    });
    _controller.addListener(() {
      setState(() {
        _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:const Color.fromRGBO(30, 31, 40, 0.7),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -50,
              left: 0,
              child: splash_animation(1, Container(
                width: width,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Assets/images/one.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
               ),
            ),
            Positioned(
              top: -100,
              left: 0,
              child:splash_animation(1.3, Container(
                width: width,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Assets/images/one.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ),
            ),
            Positioned(
              top: -150,
              left: 0,
              child: splash_animation(1.6,Container(
                width: width,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Assets/images/one.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget> [
                  const SizedBox(height: 300.0,),
                  Row(
                    children:<Widget> [
                      Container(
                        width: _animation.value*100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('Assets/images/try.png'),
                            )
                        ),
                      ),
                      splash_animation(1,
                        Text('VARDROBE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: kfontfamily,
                          ),
                        ),
                    ),
                    ],
                  ),
                  SizedBox(height:10.0),
                  splash_animation(1,
                    Text('An Intelligent Shopping Solution',
                      style: TextStyle(
                          color: const Color(0xffE1AD38),
                        fontFamily: kfontfamily,
                        fontSize: 16,
                        height: 1.4
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ) ,
      ),
    );
  }
}
