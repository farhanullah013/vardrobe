import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Screens/product_detail.dart';

import 'constants.dart';

class sale_product extends StatelessWidget {
  final int sale;
  final image_path;
  final int rating;
  final int reviews;
  final String designer;
  final String item;
  final int original_price;
  final int sale_price;
  final String docid;
  final List<dynamic> favourites;

  sale_product({this.sale, this.image_path, this.reviews, this.designer, this.item, this.original_price, this.sale_price, this.rating, this.docid, this.favourites});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
            },
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
              return product_detail(docid:docid,saleprod: true,);
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
                  image: NetworkImage(image_path),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget> [
                      Padding(
                        padding: EdgeInsets.only(top:10.0,left: 10.0),
                        child: Container(
                          child: Center(child: Text('-'+'$sale'+'%',style: TextStyle(color: Colors.white,fontSize: 12.0,fontFamily: kfontfamily),)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffFF3E3E),
                          ),
                          height: 20.0,
                          width: 40.0,
                        ),
                      ),
                    ],
                  ),
                  FirebaseAuth.instance.currentUser==null?Padding(
                    padding: EdgeInsets.only(left: 100.0,bottom: 9.0),
                    child: Container(
                      constraints: BoxConstraints.expand(height: 37.0,width: 37.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(30, 31, 40, 1.0),
                          shape: BoxShape.circle
                      ),
                      child: Icon(FontAwesomeIcons.heart,size: 17.0,color: Colors.white,),
                    ),
                  ):(favourites.length==0?Padding(
                    padding: EdgeInsets.only(left: 100.0,bottom: 9.0),
                    child: Container(
                      constraints: BoxConstraints.expand(height: 37.0,width: 37.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(30, 31, 40, 1.0),
                          shape: BoxShape.circle
                      ),
                      child: Icon(FontAwesomeIcons.heart,size: 17.0,color: Colors.white,),
                    ),
                  ):(favourites.contains(FirebaseAuth.instance.currentUser.uid)==true?Padding(
                      padding: EdgeInsets.only(left: 100.0,bottom: 9.0),
                      child: Container(
                        constraints: BoxConstraints.expand(height: 37.0,width: 37.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(30, 31, 40, 1.0),
                            shape: BoxShape.circle
                        ),
                        child: Icon(FontAwesomeIcons.solidHeart,size: 18.0,color: Color(0xffEF3651),),
                      )
                  ):Padding(
                    padding: EdgeInsets.only(left: 100.0,bottom: 9.0),
                    child: Container(
                      constraints: BoxConstraints.expand(height: 37.0,width: 37.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(30, 31, 40, 1.0),
                          shape: BoxShape.circle
                      ),
                      child: Icon(FontAwesomeIcons.heart,size: 17.0,color: Colors.white,),
                    ),
                  ))
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
                  initialRating: rating.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Container(
                  child: Text('('+'$reviews'+')',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily,),) ,
                ),
              ),
            ],
          ),
          SizedBox(height:3.0),
          Container(
            child: Text('$designer',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily),) ,
          ),
          SizedBox(height:3.0),
          Container(
            child: Text('$item',style: TextStyle(color: Colors.white,fontSize: 18.0,fontFamily: kfontfamily)) ,
          ),
          SizedBox(height:3.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget> [
              Text("\$"+'$original_price',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 14.0,fontFamily: kfontfamily,decoration: TextDecoration.lineThrough,),),
              SizedBox(width:2.0),
              Text("\$"+'$sale_price',style: TextStyle(color: Color(0xffFF3E3E),fontSize: 14.0,fontFamily: kfontfamily,),),
            ],
          ),
        ],
      ),
    );
  }
}