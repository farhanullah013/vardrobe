import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Screens/product_detail.dart';

import 'constants.dart';



class cart_item extends StatelessWidget {
  final String color;
  final String docid;
  final String item_name;
  final int quantity;
  final String size;
  final String prodid;
  final String image_url;
  final int item_price;
  final bool saleprod;

  const cart_item({this.color, this.item_name, this.quantity, this.size, this.prodid, this.image_url, this.item_price, this.saleprod, this.docid});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
            },
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
              return product_detail(saleprod: saleprod,docid: prodid,);
            }
        ));
      },
      child: Container(
        height: 120.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff2A2C36),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget> [
            Container(
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),bottomLeft:Radius.circular(8.0)),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(image_url),
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                children:<Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(item_name,style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.trashAlt,size: 23.0,color: Color(0xffEF3651),),
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection('cart').doc(docid).delete();
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Color: ",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,color: Colors.grey),),
                      Text(color,style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,color: Colors.white),),
                      SizedBox(width: 12.0),
                      Text("Size: ",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,color: Colors.grey),),
                      Text(size,style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,color: Colors.white),),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Text("Quantity: ",style: TextStyle(fontFamily: kfontfamily,fontSize: 13.0,color: Colors.grey),),
                      Text("${quantity}",style: TextStyle(fontFamily: kfontfamily,fontSize: 13.0,color: Colors.white),),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("\$"+"${item_price}",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0,color: Colors.white,),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}