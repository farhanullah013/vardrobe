import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Widgets/orders_filter.dart';

class orders_screen extends StatefulWidget {
  @override
  _orders_screenState createState() => _orders_screenState();
}

class _orders_screenState extends State<orders_screen> {
  int _defaultchipindex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromRGBO(30, 31, 40, 0.9),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left:15.0 ,right: 15.0,top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Text("My Orders",style: TextStyle(fontSize:30.0 ,fontFamily: kfontfamily),),
              Center(
                child: SizedBox(
                  width: 220.0,
                  height: 70.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: orderfilter().choicesize,
                    separatorBuilder:(BuildContext context,int index)=> const SizedBox(width: 40.0,) ,
                    itemBuilder: (BuildContext context,int index){
                      return Transform(
                        transform: new Matrix4.identity()..scale(1.2),
                        child: ChoiceChip(
                          label: Text(orderfilter().choices[index]),
                          labelStyle: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,color: Colors.white),
                          selected: _defaultchipindex==index,
                          selectedColor:Color(0xffEF3651),
                          backgroundColor:Colors.black.withOpacity(0.3),
                          onSelected: (bool value){
                            setState(() {
                              _defaultchipindex=value?index:null;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              _defaultchipindex==0?StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('orders').where('userid',isEqualTo: FirebaseAuth.instance.currentUser.uid).where('status',isEqualTo: 'processing').snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }
                    else if(snapshot.connectionState==ConnectionState.waiting){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                    }else if(snapshot.data.docs.length==0){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: Text('You have no orders yet',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                    }else{
                      final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.separated(
                            itemBuilder: (context,index){
                              Timestamp now = list[index]['date'];
                              DateTime dateNow = now.toDate();
                              String Date=dateNow.toString().substring(0,10);
                              return Container(
                                padding: EdgeInsets.all(8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xff2A2C36),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(right:10.0,left: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Order N.o: "+'${index+1}',style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,),),
                                          Text("$Date",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey),),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0,),
                                      Row(
                                        children: <Widget>[
                                          Text("Tracking number: ",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                                          Text('${list[index]['trackingnumber']}',style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey),),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text("Quantity: ",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                                              Text('${list[index]['quantity']}',style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey),),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text("Total amount: ",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                                              Text('${list[index]['totalamount']}'+"\$",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey),),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context,_){
                              return const  SizedBox(height:15.0);
                            },
                            itemCount:list.length,
                        ),
                      );
                    }
                  }
              ):StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('orders').where('userid',isEqualTo: FirebaseAuth.instance.currentUser.uid).where('status',isEqualTo: 'delivered').snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }
                    else if(snapshot.connectionState==ConnectionState.waiting){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                    }else if(snapshot.data.docs.length==0){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: Text('You have no orders yet',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                    }else{
                      final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.separated(
                          itemBuilder: (context,index){
                            String Date=list[index]['date'].toString().substring(0,10);
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xff2A2C36),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(right:10.0,left: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Order N.o: "+'${index+1}',style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,),),
                                        Text("$Date",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey),),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Row(
                                      children: <Widget>[
                                        Text("Tracking number: ",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                                        Text('${list[index]['trackingnumber']}',style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey),),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text("Quantity: ",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                                            Text('${list[index]['quantity']}',style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey),),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("Total amount: ",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                                            Text('${list[index]['totalamount']}'+"\$",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey),),
                                          ],
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context,_){
                            return const  SizedBox(height:15.0);
                          },
                          itemCount:list.length,
                        ),
                      );
                    }
                  }
              ),
              const SizedBox(height: 20.0,),
              ],
            ),
          ),
        ),
    );
  }
}
