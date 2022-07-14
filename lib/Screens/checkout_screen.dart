import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vardrobe/Screens/success_screen.dart';
import 'package:vardrobe/Services/recommendation.dart';
import 'package:vardrobe/Services/stripe_payment.dart';
import 'package:vardrobe/Widgets/address_widget.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:hover_effect/hover_effect.dart';

class checkout_screen extends StatefulWidget {
  final int totalamount;

  const checkout_screen({this.totalamount});
  @override
  _checkout_screenState createState() => _checkout_screenState();
}

class _checkout_screenState extends State<checkout_screen> {
  @override
  void initState() {
    stripe_payment.init();// initializing the stripe payment with options
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          recommend.recommendfromcart();
          return Scaffold(
            backgroundColor: const  Color.fromRGBO(30, 31, 40, 1.0),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 60.0,left: 15.0,right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: Text('We also recommend these products',style: TextStyle(fontFamily:"Nunito-BoldItalic",fontSize: 18.0),)),
                    SizedBox(height: 20.0,),
                    FutureBuilder<Map<String,dynamic>>(
                    future:recommend.recommendfromcart(),
                    builder: (BuildContext con,snapshot){
                      if(snapshot.hasError){
                        print(snapshot.error);
                        return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.4,child:
                        Center(child: SizedBox(width:double.infinity,height:70.0,child: Text("Something went wrong, please try again",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),))));
                      }else if(snapshot.connectionState==ConnectionState.waiting){
                        return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                        Center(child: SizedBox(width:70.0,height:70.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                      }else{
                        return SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height/1.2,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.keys.length,
                            itemBuilder: (context,index){
                              double price=snapshot.data["$index"]["actual_price"];
                              price=price/152.0;
                              return GestureDetector(
                                onTap: ()async{
                                  await launch(snapshot.data["$index"]["product_url"]);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget>[
                                    Container(
                                      height: 180.0,
                                      width: 150.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18.0),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot.data["$index"]["href"]),
                                            fit: BoxFit.fill,
                                          ),
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
                                            initialRating:snapshot.data["$index"]["ratings"],
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
                                            child: Text('('+'${snapshot.data["$index"]["number_of_ratings"]}'+')',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily,),) ,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height:3.0),
                                    Container(
                                      child: Text('${snapshot.data["$index"]["brand"]}',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily),) ,
                                    ),
                                    SizedBox(height:3.0),
                                    Expanded(
                                      child: Container(
                                        child: Text('${snapshot.data["$index"]["title"]}',style: TextStyle(color: Colors.white,fontSize: 18.0,fontFamily: kfontfamily),) ,
                                      ),
                                    ),
                                    SizedBox(height:3.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:<Widget> [
                                        Text("\$"+'${price.round()}',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 16.0,fontFamily: kfontfamily,),),
                                        SizedBox(width:2.0),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // here we can manage how the items in the grid will look, 2 items per row, with aspect ratio(size) and space between then and space between the current row and other rows
                              crossAxisCount: 2,
                              childAspectRatio: 0.5,
                              crossAxisSpacing: 70,
                              mainAxisSpacing: 10.0,
                            ),
                          ),
                        );;
                      }
                    }
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 31, 40, 1.0),
      appBar: AppBar(
        elevation: 6.0,
        backgroundColor:Color.fromRGBO(30, 31, 40, 1.0),
        title: Text("Place Order",style: TextStyle(fontFamily: kfontfamily,fontSize: 28.0),),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left:10.0 ,right:10.0,top: 20.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
            builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasError){
                return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
              }
              else if(snapshot.connectionState==ConnectionState.waiting){
                return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
              }else{
                Map<String,dynamic> data=snapshot.data.data();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                address_widget(addresstype: "Shipping address",),
                const SizedBox(height: 15.0,),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child:Text(data['shippingaddress'],style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                  decoration: BoxDecoration(
                    color: Color(0xff2A2C36),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(height: 20.0,),
                address_widget(addresstype: "Billing address",),
                const SizedBox(height: 15.0,),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child:Text(data['billingaddress'],style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                  decoration: BoxDecoration(
                    color: Color(0xff2A2C36),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Text("Payment Method",style: TextStyle(fontSize:18.0 ,fontFamily: kfontfamily),),
                const SizedBox(height: 15.0,),
                Container(
                  height: 200.0,
                  width: double.infinity,
                  child: HoverCard(
                    builder: (context,hovering){
                   return Container(
                      padding: EdgeInsets.all(8.0),
                      width: double.infinity,
                      height: 215.0,
                     color: Colors.black,
                      child:Padding(
                        padding: EdgeInsets.only(left: 8.0,right: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(width: 19.0,height:19.0 ,
                                    child: Image(image: AssetImage("Assets/images/contact_less.png",))),
                                Container(width: 55.0,height:55.0 ,
                                    child: Image(image: AssetImage("Assets/images/mastercard.png",)))
                              ],
                            ),
                            SizedBox(height: 25.0,),
                            Text("5412  5198  XXXX  9874",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                            SizedBox(height: 25.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("CARDHOLDER",style: TextStyle(fontFamily: kfontfamily,fontSize: 11.0),),
                                Text("VALID THRU",style: TextStyle(fontFamily: kfontfamily,fontSize: 11.0),),
                              ],
                            ),
                            SizedBox(height: 2.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Waseem Saif-al-Din Basara",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                Text("0/2024",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    }
                  ),
                ),
                const SizedBox(height:80.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Total amount: ",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                    Text("\$"+"${widget.totalamount}",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                  ],
                ),
                const SizedBox(height:30.0),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0,right: 20.0),
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
                        primary: Color(0xffEF3651)
                      ),
                      onPressed: () async {
                        int amountobepaid=widget.totalamount*100;
                        String finalamount=amountobepaid.toString();
                        await stripe_payment.paywithnewcard(payment_amount:finalamount,currency: 'USD');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(stripe_payment.message,style: TextStyle(fontFamily: kfontfamily,fontSize: 16.0),),
                            backgroundColor: Colors.blueAccent,
                          ),
                        );
                        if(stripe_payment.message=='Payment successfull'){
                         QuerySnapshot qs=await FirebaseFirestore.instance.collection('cart').where('user_id',isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
                          await FirebaseFirestore.instance.collection('orders').add({
                            'date':DateTime.now(),
                            'quantity':qs.docs.length,
                            'status':'processing',
                            'totalamount':widget.totalamount,
                            'trackingnumber':'Awzxf1245',
                            'userid':FirebaseAuth.instance.currentUser.uid,
                          });
                         final List<QueryDocumentSnapshot> list=qs.docs;
                         for(int i=0;i<list.length;i++){
                           await FirebaseFirestore.instance.collection('cart').doc(list[i].id).delete();
                         }
                          Navigator.push(context, PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                              },
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                return success_screen();
                              }
                          ));
                        }
                      },
                      child: Text('Confirm',style: TextStyle(fontSize: 20.0,fontFamily: kfontfamily),),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,)
              ],
            );
            }
            }
          ),
        ),
      ),
    );
  }
}
