import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Screens/product_detail.dart';

import 'constants.dart';

class fav_sale_prod extends StatelessWidget {
  final String image_path;
  final int rating;
  final int reviews;
  final String designer;
  final String item;
  final int original_price;
  final int sale_price;
  final int sale;
  final String docid;

  const fav_sale_prod({this.image_path, this.rating, this.reviews, this.designer, this.item, this.original_price,this.sale_price, this.sale, this.docid});
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget> [
                      Padding(
                        padding: EdgeInsets.only(top:10.0,left: 10.0),
                        child: Container(
                          child: Center(child: Text('-'+'$sale'+'%',style: TextStyle(color: Colors.white,fontSize: 13.0,fontFamily: kfontfamily),)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffFF3E3E),
                          ),
                          height: 20.0,
                          width: 40.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6.0,right: 5.0),
                        child: Container(
                            constraints: BoxConstraints.expand(height: 30.0,width: 30.0),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(30, 31, 40, 1.0),
                                shape: BoxShape.circle
                            ),
                            child: IconButton(icon: Icon(FontAwesomeIcons.times,color: Colors.white,size: 14.0,), onPressed: (){
                              FirebaseFirestore.instance.collection('sale_product').doc(docid).update({'favourite':FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid])});
                            })
                        ),
                      )
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
                  initialRating: rating.toDouble(),
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
            child: Text('$item',style: TextStyle(color: Colors.white,fontSize: 20.0,fontFamily: kfontfamily),) ,
          ),
          SizedBox(height:3.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget> [
              Text('$original_price''\$',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 15.0,fontFamily: kfontfamily,decoration: TextDecoration.lineThrough,),),
              SizedBox(width:2.0),
              Text('$sale_price''\$',style: TextStyle(color: Color(0xffFF3E3E),fontSize: 15.0,fontFamily: kfontfamily,),),
            ],
          ),
        ],
      ),
    );
  }
}