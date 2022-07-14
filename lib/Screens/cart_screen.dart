import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vardrobe/Screens/checkout_screen.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Widgets/cart_item.dart';
import 'package:vardrobe/Widgets/constants.dart';

import 'navigation_screen.dart';

class cart_Screen extends StatefulWidget {
  @override
  _cart_ScreenState createState() => _cart_ScreenState();
}

class _cart_ScreenState extends State<cart_Screen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return Navigator.push(context, PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
            },
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
              return navigation_screen();
            }
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:const  Color.fromRGBO(30, 31, 40, 0.8),
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
            onPressed: (){
              return Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                    return navigation_screen();
                  }
              ));
            },
          ),
          title: Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text("My Cart",style: TextStyle(fontFamily: kfontfamily,fontSize: 30.0),),
          ),
        ),
        body: Provider.of<authenticationanduserprovider>(context).isloggedin()==true?SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0,left: 10.0,right: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('cart').where('user_id',isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
                if(snapshot.hasError){
                  return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                }else if(snapshot.connectionState==ConnectionState.waiting){
                  return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                  Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                }else if(snapshot.data.docs.length==0){
                  return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                  Center(child: Text('You have no products in cart',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                }else{
                  int total=0;
                  final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                  list.forEach((element) {
                    Map<String,dynamic> data=element.data();
                    total+=data['item_price'];
                  });
                  return Column(
                    children:<Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height/1.7,
                        child: ListView.separated(
                        separatorBuilder: (context,_){
                          return const  SizedBox(height:15.0);
                        },
                    itemCount: snapshot.data.docs.length,
                    scrollDirection:Axis.vertical,
                    itemBuilder: (context,index){
                    return cart_item(color:list[index]['color'],item_name:list[index]['item_name'], quantity:list[index]['quantity'], size:list[index]['size'], prodid:list[index]['productid'], image_url:list[index]['image_url'], item_price:list[index]['item_price'],saleprod:list[index]['saleprod'],docid: list[index].id);
                    },
                    ),
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget> [
                          Text("Total Amount: ",style: TextStyle(fontFamily: kfontfamily,fontSize:18.0 ),),
                          Text("\$"+"$total",style: TextStyle(fontFamily: kfontfamily,fontSize:22.0 ),),
                        ],
                      ),
                      SizedBox(height: 15.0,),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 3),
                              ),
                            ]
                        ),
                        height: 55.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              primary: Color(0xffEF3651)
                          ),
                          onPressed: (){
                            Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 500),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                  return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                  return checkout_screen(totalamount: total,);
                                }
                            ));
                          },
                          child: Text("CHECK OUT",style: TextStyle(fontSize: 20.0,fontFamily: kfontfamily),),
                        ),
                      ),
                      SizedBox(height: 15.0,),
                    ],
                  );
                }
              }
            ),
          ),
        ):Container(
          child: Center(
            child: Text("Please Login first",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
          ),
        ),
      ),
    );
  }
}


