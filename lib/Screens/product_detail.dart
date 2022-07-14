import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vardrobe/Screens/cart_screen.dart';
import 'package:vardrobe/Screens/product_image_screen.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Services/post_review.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:toast/toast.dart';

import 'chat_screen.dart';
import 'login_screen.dart';
import 'package:carousel_pro/carousel_pro.dart';

class product_detail extends StatefulWidget {
  final String docid;
  final bool saleprod;
  product_detail({this.docid, this.saleprod});

  @override
  _product_detailState createState() => _product_detailState();
}

class _product_detailState extends State<product_detail> {
  int _defaultchipindex=0;
  int _defaultcolorindex=0;
  int _quantity=1;
  int _rating=1;

  final _form=GlobalKey<FormState>();
  TextEditingController _reviewtextediting=TextEditingController();

  bool _saveform(){
    final isvalid=_form.currentState.validate();
    if(!isvalid){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(Icons.shopping_cart_outlined,color: Colors.black,size: 28.0,),
        backgroundColor: Color(0xffEF3651),
        onPressed: (){
          Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true?Navigator.push(context, PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
              },
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                return cart_Screen();
              }
          )):Navigator.push(context, PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
              },
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                return login_screen();
              }
          ));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff2D4049),
        child: Container(
          height: 60.0,
          child: Padding(
            padding: EdgeInsets.only(right: 10.0,left: 15.0),
            child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget> [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
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
                  onPressed: (){
                    Provider.of<authenticationanduserprovider>(context,listen:false).isloggedin()==true?
                    showModalBottomSheet(
                        context: context,
                        builder:(context)=>Container(
                          decoration: BoxDecoration(
                              color:const  Color.fromRGBO(30, 31, 40, 1.0),
                              borderRadius: BorderRadius.only(topRight:Radius.circular(35.0) ,topLeft: Radius.circular(35.0),)
                          ),
                          child: SingleChildScrollView(
                            child: StatefulBuilder(
                              builder: (BuildContext con,StateSetter state){
                                return Padding(
                                  padding: EdgeInsets.only(top: 10.0,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget> [
                                      const SizedBox(height: 20.0,),
                                      Text("Select Size",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                      const SizedBox(height: 30.0,),
                                      StreamBuilder(
                                        stream:widget.saleprod==true?FirebaseFirestore.instance.collection('sale_product').doc(widget.docid).snapshots():FirebaseFirestore.instance.collection('products').doc(widget.docid).snapshots(),
                                        builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
                                          if(snapshot.hasError){
                                          return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                                          }else if(snapshot.connectionState==ConnectionState.waiting){
                                          return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                                          Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                                          }
                                          else {
                                            int price=0;
                                            Map<String, dynamic> data = snapshot.data.data();
                                            List<String> sizes = new List<String>.from(data['sizes']);
                                            Map<String, dynamic> variations = data['variations'];
                                            List<String> colors = new List<String>.from(variations.keys);
                                            widget.saleprod==true?price=price+data['saleprice']:price=price+data['price'];
                                            return Column(
                                              children: <Widget>[
                                                  Padding(
                                                  padding: EdgeInsets.only(left: 12.0),
                                                child: SizedBox(
                                                height: 50.0,
                                                child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children:<Widget> [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width/2,
                                                child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: sizes.length,
                                                separatorBuilder:(BuildContext context,int index)=> const SizedBox(width: 15.0,) ,
                                                itemBuilder: (BuildContext context,int index){
                                                return Padding(
                                                  padding: EdgeInsets.only(right: 12.0),
                                                  child: Transform(
                                                  transform: new Matrix4.identity()..scale(1.2),
                                                  child: ChoiceChip(
                                                  label: Text(sizes[index]),
                                                  labelStyle: TextStyle(fontFamily: kfontfamily,fontSize: 16.0,color: Colors.white),
                                                  selected: _defaultchipindex==index,
                                                  selectedColor:Color(0xffEF3651),
                                                  backgroundColor:Colors.black.withOpacity(0.3),
                                                  onSelected: (bool value){
                                                  state((){
                                                  _defaultchipindex=value?index:null;
                                                  });
                                                  },
                                                  ),
                                                  ),
                                                );
                                                },
                                                ),
                                                ),
                                                ],
                                                ),
                                                ),
                                                ),
                                                const SizedBox(height: 50.0,),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 12.0,right: 12.0),
                                                  child: SizedBox(
                                                    height: 50.0,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:<Widget> [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width/2,
                                                          child: ListView.separated(
                                                            scrollDirection: Axis.horizontal,
                                                            itemCount: colors.length,
                                                            separatorBuilder:(BuildContext context,int index)=> const SizedBox(width: 15.0,) ,
                                                            itemBuilder: (BuildContext context,int index){
                                                              return Padding(
                                                                padding: EdgeInsets.only(right: 12.0),
                                                                child: Transform(
                                                                  transform: new Matrix4.identity()..scale(1.2),
                                                                  child: ChoiceChip(
                                                                    label: Text(colors[index]),
                                                                    labelStyle: TextStyle(fontFamily: kfontfamily,fontSize: 16.0,color: Colors.white),
                                                                    selected: _defaultcolorindex==index,
                                                                    selectedColor:Color(0xffEF3651),
                                                                    backgroundColor:Colors.black.withOpacity(0.3),
                                                                    onSelected: (bool value){
                                                                      state((){
                                                                        _defaultcolorindex=value?index:null;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 50.0,),
                                                Text("Select Quantity",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                                const SizedBox(height: 30.0,),
                                                Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children:<Widget> [
                                                IconButton(
                                                icon: Icon(FontAwesomeIcons.plusSquare,color: Colors.white,),
                                                onPressed: (){
                                                state((){
                                                if(_quantity<10){
                                                _quantity+=1;
                                                }
                                                });
                                                },
                                                ),
                                                const SizedBox(width: 5.0,),
                                                Container(
                                                decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: Colors.grey,
                                                ),
                                                width: 80.0,
                                                height: 35.0,
                                                child: TextField(
                                                  enabled: false,
                                                decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                top: 5.0,
                                                ),
                                                counterText: "",
                                                filled: true,
                                                fillColor: Color(0xff2A2C36),
                                                hintText: '$_quantity',
                                                hintStyle: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: 'Nunito-Regular',
                                                color: Colors.white,
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                  borderSide:
                                                  BorderSide(color: Color(0xff2A2C36), width: 1.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                borderSide:
                                                BorderSide(color: Colors.red, width: 2.0),
                                                ),
                                                ),
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                maxLength: 1,
                                                ),
                                                ),
                                                const SizedBox(width: 5.0,),
                                                IconButton(
                                                icon: Icon(FontAwesomeIcons.minusSquare,color: Colors.white,),
                                                onPressed: (){
                                                state((){
                                                if(_quantity>1){
                                                _quantity-=1;
                                                }
                                                });
                                                },
                                                ),
                                                ],
                                                ),
                                                const SizedBox(height: 80.0,),
                                                Padding(
                                                padding: EdgeInsets.only(left: 100.0,right: 100.0),
                                                child: Container(
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
                                                height: 50.0,
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                shape:RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0),
                                                ) ,
                                                primary: Color(0xffEF3651)
                                                ),
                                                onPressed: () async {
                                                  try{
                                                  DocumentReference dr=await FirebaseFirestore.instance.collection('cart').add({
                                                  'color':colors[_defaultcolorindex],
                                                  'image_url':data['imageurl'][0],
                                                  'item_name':data['name'],
                                                  'item_price':_quantity*price,
                                                  'productid':snapshot.data.id,
                                                    'quantity':_quantity,
                                                    'saleprod':widget.saleprod,
                                                    'size':sizes[_defaultchipindex],
                                                    'user_id':FirebaseAuth.instance.currentUser.uid,
                                                });
                                                  if(dr.id!=null){
                                                    Navigator.pop(context);
                                                    Toast.show("Item added to cart", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                                  }else{
                                                    Toast.show("Operation Unsuccessful", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                                  }}catch(e){
                                                    print(e.toString());
                                                  }
                                                },
                                                child: Text("Add",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                                ),
                                                ),
                                                ),
                                                const SizedBox(height: 15.0,),
                                                    ],);
                                        }
                                        }
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ):Navigator.push(context, PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 600),
                        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                          return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                        },
                        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                          return login_screen();
                        }
                    ));
                  },
                  child: Text('Add to cart',style: TextStyle(fontSize: 13.0,fontFamily: kfontfamily),),
                ),
              ),
            ),
                SizedBox(width:5.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
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

                        DocumentSnapshot vendordata=widget.saleprod==true?await FirebaseFirestore.instance.collection('sale_product').doc(widget.docid).get():
                        await FirebaseFirestore.instance.collection('products').doc(widget.docid).get();

                        Map<String,dynamic> data=vendordata.data();

                        Provider.of<authenticationanduserprovider>(context,listen:false).isloggedin()==true?Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 500),
                            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                            },
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                              return chat_screen(prodid: widget.docid,vendor: data['vendorname'],);
                            }
                        )):Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 500),
                            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                            },
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                              return login_screen();
                            }
                        ));
                      },
                      child: Text('Chat',style: TextStyle(fontSize: 13.0,fontFamily: kfontfamily),),
                    ),
                  ),
                ),
                SizedBox(width:5.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
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
                        Provider.of<authenticationanduserprovider>(context,listen:false).isloggedin()==true?
                        showModalBottomSheet(
                          context: context,
                          builder:(context)=>Container(
                            decoration: BoxDecoration(
                                color:const  Color.fromRGBO(30, 31, 40, 1.0),
                                borderRadius: BorderRadius.only(topRight:Radius.circular(35.0) ,topLeft: Radius.circular(35.0),)
                            ),
                            child: StatefulBuilder(
                              builder: (BuildContext con,StateSetter state){
                                return SingleChildScrollView(
                                  child: SizedBox(
                                    height: 500.0,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10.0,),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children:<Widget> [
                                          Text("Please give your opinion here",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                          const SizedBox(height: 20.0,),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                            child: Form(
                                              key: _form,
                                              child: TextFormField(
                                                maxLength: 80,
                                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                                controller:_reviewtextediting ,
                                                validator:(text){
                                                  if(text.isEmpty){
                                                    return 'Review cannot be empty';
                                                  }else if(!text.contains(new RegExp(r'^[A-Za-z ]+$'))){
                                                    return "Only alphabets allowed";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  counter: Offstage(),
                                                  filled: true,
                                                  fillColor: Color(0xff2A2C36),
                                                  hintText: '',
                                                  hintStyle: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: kfontfamily,
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Color(0xff2A2C36), width: 1.0),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.red, width: 2.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 25.0,),
                                          Text("Rate out of 5",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                          const SizedBox(height: 25.0,),
                                          RatingBar.builder(
                                            itemSize: 25.0,
                                            initialRating: 1,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                            itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),
                                            onRatingUpdate: (rating) {
                                              _rating=rating.toInt();
                                            },
                                          ),
                                          const SizedBox(height: 25.0,),
                                          Padding(
                                            padding: EdgeInsets.only(left: 100.0,right: 100.0),
                                            child: Container(
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
                                              height: 50.0,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25.0),
                                                  ),
                                                  primary:  Color(0xffEF3651),
                                                ),
                                                onPressed: (){
                                                  bool proceed=_saveform();
                                                  if(proceed==true){
                                                    widget.saleprod==true?post_review.postreview(rating:_rating, review:_reviewtextediting.text,
                                                         ts:Timestamp.fromDate(DateTime.now()),sale: true,docid: widget.docid):
                                                        post_review.postreview(rating:_rating, review:_reviewtextediting.text,
                                                        ts:Timestamp.fromDate(DateTime.now()),sale: false,docid: widget.docid);
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text("Post",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20.0,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ):Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 500),
                            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                            },
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                              return login_screen();
                            }
                        ));
                      },
                      child: Text('Write a Review',style: TextStyle(fontSize: 13.0,fontFamily: kfontfamily),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar:AppBar(
        centerTitle: true,
        actions:<Widget> [
          IconButton(icon:Icon(Icons.share,color: Colors.white,), onPressed: () async {
            final RenderBox box = context.findRenderObject() as RenderBox;
            await Share.share('Thankyou for using our app',
                subject: 'Share this product with anyone!',
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
          },),
          FirebaseAuth.instance.currentUser!=null?StreamBuilder<DocumentSnapshot>(
            stream: widget.saleprod==true?FirebaseFirestore.instance.collection('sale_product').doc(widget.docid).snapshots():FirebaseFirestore.instance.collection('products').doc(widget.docid).snapshots(),
            builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
              if(snapshot.hasError){
                return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
              }
              else if(snapshot.connectionState==ConnectionState.waiting){
                return Icon(FontAwesomeIcons.spinner,color: Color(0xffEF3651));
              }else{
               Map<String,dynamic> data=snapshot.data.data();
               List<dynamic> fav=data['favourite'];
                   return IconButton(
                       icon:Icon(fav.contains(FirebaseAuth.instance.currentUser.uid)==true?Icons.favorite:Icons.favorite_border,
                           color:fav.contains(FirebaseAuth.instance.currentUser.uid)==true?Colors.pink:Colors.white),
                       onPressed: (){
                           if(fav.contains(FirebaseAuth.instance.currentUser.uid)){
                             widget.saleprod==true?FirebaseFirestore.instance.collection('sale_product').doc(widget.docid).update({'favourite':FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid])}):
                             FirebaseFirestore.instance.collection('products').doc(widget.docid).update({'favourite':FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid])});
                             Toast.show("Removed from favourites", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                           }else{
                             widget.saleprod==true?FirebaseFirestore.instance.collection('sale_product').doc(widget.docid).update({'favourite':FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid])}):
                             FirebaseFirestore.instance.collection('products').doc(widget.docid).update({'favourite':FieldValue.arrayUnion([FirebaseAuth.instance.currentUser.uid])});
                             Toast.show("Added to favourites", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                           }
                       }
                   );
               }
              }
          ):IconButton(
              icon:Icon(FontAwesomeIcons.heart,color:Colors.white,),
              onPressed: (){
                Navigator.push(context, PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                },
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                return login_screen();
                }
                ));
              }
    ),
        ],
        backgroundColor:const Color.fromRGBO(30, 31, 40, 1.0) ,
        leading: IconButton(
        icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
          onPressed: (){
          Navigator.pop(context);
              },
            ),
        title: Text("Product Details",style: TextStyle(fontFamily: kfontfamily,fontSize: 24.0),),
          ),
      backgroundColor: const  Color.fromRGBO(30, 31, 40, 1.0),
        body: SingleChildScrollView(
          child: Column(
            children:<Widget>[
              StreamBuilder<DocumentSnapshot>(
              stream:widget.saleprod==true?FirebaseFirestore.instance.collection('sale_product').doc(widget.docid).snapshots():FirebaseFirestore.instance.collection('products').doc(widget.docid).snapshots(),
              builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
                if(snapshot.hasError){
                  return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                }else if(snapshot.connectionState==ConnectionState.waiting){
                  return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                  Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                }
                else {
                  Map<String, dynamic> data = snapshot.data.data();
                  int rating = data['rating'];
                  List<String> prodpiclink = new List<String>.from(
                      data['imageurl']);
                  List<Widget> productwig = [];
                  prodpiclink.forEach((element) {
                    productwig.add(Image.network(element, fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.pink,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black),
                            strokeWidth: 2.0,
                            value: loadingProgress.expectedTotalBytes != null ?
                            loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },));
                  });
                  Map<String, dynamic> variations = data['variations'];
                  List<String> variationpics = new List<String>.from(
                      variations.values);
                  List<String> sizes = new List<String>.from(data['sizes']);
                  List<String> details = new List<String>.from(data['details']);
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 250.0,
                        child: GestureDetector(
                          child: Carousel(
                            animationCurve: Curves.fastOutSlowIn,
                            animationDuration: const Duration(milliseconds: 100),
                            dotSize: 5.0,
                            dotIncreasedColor: const Color(0xFFFF335C),
                            dotColor: Colors.white,
                            dotBgColor: Colors.transparent,
                            dotPosition: DotPosition.bottomCenter,
                            dotVerticalPadding: 10.0,
                            indicatorBgPadding: 7.0,
                            autoplay: false,
                            images: productwig,
                          ),
                          onTap: (){
                            Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 600),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                  return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                  return product_image_screen(prodimage:productwig,);
                                }
                            ));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        width: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Icon(FontAwesomeIcons.image,
                                  color: Color(0xffEF3651), size: 20.0,)),
                            const SizedBox(width: 20.0,),
                            Text("${productwig.length}", style: TextStyle(
                                color: Colors.black, fontFamily: kfontfamily),)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0,),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white24.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Text('${data['brand']}', style: TextStyle(
                                        fontFamily: kfontfamily,
                                        fontSize: 25.0),),
                                    Text(widget.saleprod == true ? "\$"+
                                        '${data['saleprice']}' : "\$"+
                                        '${data['price']}', style: TextStyle(
                                        fontFamily: kfontfamily,
                                        fontSize: 25.0),),
                                  ],
                                ),
                                const SizedBox(height: 3.0,),
                                Text('${data['name']}', style: TextStyle(
                                    fontFamily: kfontfamily,
                                    fontSize: 15.0,
                                    color: Colors.grey),),
                                SizedBox(height: 6.0,),
                                Row(
                                  children: <Widget>[
                                    RatingBar.builder(
                                      itemSize: 13.0,
                                      initialRating: rating.toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      itemBuilder: (context, _) =>
                                          Icon(
                                            Icons.star, color: Colors.amber,),
                                    ),
                                    Text('(' + '${data['numreviews']}' + ')',
                                      style: TextStyle(color: Colors.grey,
                                        fontSize: 13.0,
                                        fontFamily: kfontfamily,),),
                                  ],
                                ),
                                SizedBox(height: 9.0,),
                                Text('${data['description']}', style: TextStyle(
                                  fontFamily: kfontfamily, fontSize: 15.0,),),
                                const SizedBox(height: 3.0,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white24.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Variants', style: TextStyle(
                                    fontFamily: kfontfamily, fontSize: 25.0),),
                                const SizedBox(height: 8.0,),
                                SizedBox(
                                  height: 70.0,
                                  child: ListView.separated(
                                    separatorBuilder: (context, _) {
                                      return const SizedBox(width: 15.0);
                                    },
                                    itemCount: variationpics.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 5.0, left: 5.0),
                                        child: Container(
                                          height: 50.0,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius: BorderRadius.circular(
                                                5.0),
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: NetworkImage(
                                                  variationpics[index]),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 6.0,),
                                Text('Sizes', style: TextStyle(
                                    fontFamily: kfontfamily, fontSize: 25.0),),
                                SizedBox(height: 6.0,),
                                SizedBox(
                                  height: 60.0,
                                  child: ListView.separated(
                                    separatorBuilder: (context, _) {
                                      return const SizedBox(width: 15.0);
                                    },
                                    itemCount: sizes.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 5.0, left: 5.0),
                                        child: Container(
                                          height: 50.0,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey),
                                            borderRadius: BorderRadius.circular(
                                                5.0),
                                          ),
                                          child: Center(child: Text(
                                            sizes[index], style: TextStyle(
                                              fontFamily: kfontfamily,
                                              fontSize: 25.0),)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0,),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white24.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Details', style: TextStyle(
                                    fontFamily: kfontfamily, fontSize: 25.0),),
                                SizedBox(height: 8.0,),
                                SizedBox(
                                  height: 100.0,
                                  child: ListView.separated(
                                    separatorBuilder: (context, _) {
                                      return const SizedBox(width: 15.0);
                                    },
                                    itemCount: details.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: <Widget>[
                                          Icon(Icons.circle, size: 10.0,
                                            color: Colors.black,),
                                          SizedBox(width: 6.0,),
                                          Text(details[index], style: TextStyle(
                                              fontFamily: kfontfamily,
                                              fontSize: 16.0,
                                              color: Colors.grey),),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 8.0,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  );
                }
              }
    ),
                      StreamBuilder<QuerySnapshot>(
                        stream: widget.saleprod==true?FirebaseFirestore.instance.collection('sale_product').doc(widget.docid).collection('reviews').snapshots():
                        FirebaseFirestore.instance.collection('products').doc(widget.docid).collection('reviews').snapshots(),
                        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
                          if(snapshot.hasError){
                            return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                          }else if(snapshot.connectionState==ConnectionState.waiting){
                            return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                            Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                          }else{
                            final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                            return Padding(
                              padding: EdgeInsets.only(left:8.0 ,right: 8.0,),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white24.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding:EdgeInsets.only(left:7.0 ,right: 5.0,top: 7.0 ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:<Widget>[
                                          Text('Reviews',style: TextStyle(fontFamily: kfontfamily,fontSize: 25.0 ),
                                          ),
                                          Text('${snapshot.data.size}'+' Reviews',style: TextStyle(fontFamily: kfontfamily,fontSize: 16.0,color: Colors.grey),),
                                          ],
                                      ),
                                      SizedBox(height:8.0,),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height:300.0,
                                              child: ListView.separated(
                                                separatorBuilder: (context, _) {
                                                  return Divider(
                                                    color: Colors.black,
                                                    indent: 20.0,
                                                    endIndent: 20.0,
                                                    thickness: 1.0,
                                                  );
                                                },
                                                itemCount: snapshot.data.size,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) {
                                                  int irating=list[index]['rating'];
                                                  double drating=irating.toDouble();
                                                  Timestamp ts=list[index]['date'];
                                                  DateTime dt=ts.toDate();
                                                  String date;
                                                  date=dt.toString().substring(0,10);
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              CircleAvatar(backgroundImage:NetworkImage(list[index]['imageurl']),backgroundColor:Colors.grey,radius: 25.0,),
                                                              SizedBox(width:3.0,),
                                                              Text(list[index]['name'],style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,),),
                                                            ],
                                                          ),
                                                          Text(date,style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,color: Colors.grey),),
                                                        ],
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      ),
                                                      SizedBox(height: 10.0,),
                                                      RatingBar.builder(
                                                        itemSize: 11.0,
                                                        initialRating: drating,
                                                        minRating: 1,
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: false,
                                                        itemCount: 5,
                                                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                        itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),
                                                      ),
                                                      SizedBox(height:6.0,),
                                                      Padding(
                                                          padding: EdgeInsets.only(left: 3.0,bottom: 3.0),
                                                          child: Text(list[index]['review'],style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,),)),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height:6.0,),
                                          ],
                                        ),
                                      ),
                                      ],
                                  ),
                                ),
                              ),
                            );
                              }
                            },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
          ),
        );
  }
}
