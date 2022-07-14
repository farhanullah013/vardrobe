import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vardrobe/Screens/arviewscreen.dart';
import 'package:vardrobe/Widgets/constants.dart';

class arproductscreen extends StatefulWidget {
  @override
  _arproductscreenState createState() => _arproductscreenState();
}

class _arproductscreenState extends State<arproductscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromRGBO(30, 31, 40, 0.8),
        title: Text("AugmentedReality",style: TextStyle(fontFamily: kfontfamily,fontSize: 26.0),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                            return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                          },
                          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                            return arviewscreen(image: "cap.png",);
                          }
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Container(
                          height: 200.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: Colors.white,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('Assets/images/cap.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget> [
                                    Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                              width: 95.0,
                              child: RatingBar.builder(
                                itemSize: 15.0,
                                initialRating: 3.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Container(
                                child: Text('('+'25'+')',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily,),) ,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:3.0),
                        Container(
                          child: Text('Bandai',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily),) ,
                        ),
                        SizedBox(height:3.0),
                        Container(
                          child: Text('Cap ',style: TextStyle(color: Colors.white,fontSize: 20.0,fontFamily: kfontfamily),) ,
                        ),
                        SizedBox(height:3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget> [
                            Text("\$"+'5',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 15.0,fontFamily: kfontfamily,),),
                            SizedBox(width:2.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                            return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                          },
                          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                            return arviewscreen(image: "shirt.png",);
                          }
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Container(
                          height: 200.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: Colors.white,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('Assets/images/shirt.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget> [
                                    Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                              width: 95.0,
                              child: RatingBar.builder(
                                itemSize: 15.0,
                                initialRating: 5.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Container(
                                child: Text('('+'5'+')',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily,),) ,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:3.0),
                        Container(
                          child: Text('Fisher',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily),) ,
                        ),
                        SizedBox(height:3.0),
                        Container(
                          child: Text('Shirt',style: TextStyle(color: Colors.white,fontSize: 20.0,fontFamily: kfontfamily),) ,
                        ),
                        SizedBox(height:3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget> [
                            Text("\$"+'10',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 15.0,fontFamily: kfontfamily,),),
                            SizedBox(width:2.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                            return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                          },
                          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                            return arviewscreen(image: "glasses.png",);
                          }
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Container(
                          height: 200.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: Colors.white,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('Assets/images/glasses.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget> [
                                    Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                              width: 95.0,
                              child: RatingBar.builder(
                                itemSize: 15.0,
                                initialRating: 4.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Container(
                                child: Text('('+'10'+')',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily,),) ,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:3.0),
                        Container(
                          child: Text('Vincent Chase',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily),) ,
                        ),
                        SizedBox(height:3.0),
                        Container(
                          child: Text('Shades',style: TextStyle(color: Colors.white,fontSize: 20.0,fontFamily: kfontfamily),) ,
                        ),
                        SizedBox(height:3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget> [
                            Text("\$"+'50',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 15.0,fontFamily: kfontfamily,),),
                            SizedBox(width:2.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
