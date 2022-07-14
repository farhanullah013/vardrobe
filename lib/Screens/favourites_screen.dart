import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Widgets/fav_prod.dart';
import 'package:vardrobe/Widgets/fav_sale_prod.dart';
import 'package:vardrobe/Widgets/filters_and_sort.dart';
import 'package:vardrobe/Widgets/sort_filters_and_catsearch.dart';

class favourites_screen extends StatefulWidget {

  @override
  _favourites_screenState createState() => _favourites_screenState();
}

class _favourites_screenState extends State<favourites_screen> {
  String _filtervalue=sortfilters.sortfilter[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      centerTitle: true,
      backgroundColor:const Color.fromRGBO(30, 31, 40, 0.9) ,
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      title: Text("Favourites",style: TextStyle(fontFamily: kfontfamily,fontSize: 28.0),),
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0),
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('products').where('favourite',arrayContains: FirebaseAuth.instance.currentUser.uid).snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasError){
                    return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                  }
                  else if(snapshot.connectionState==ConnectionState.waiting){
                    return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                    Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                  }else if(snapshot.data.size==0){
                    return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.5,child:
                    Center(child: Text('You have no favourites',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                  }else{
                    final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                    return Column(
                      children:<Widget>[
                        Center(child: Text('Favourite Products',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),),
                        SizedBox(height: 10.0,),
                        SizedBox(
                          height: 300.0,
                          child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: list.length,
                          itemBuilder: (context,index){
                            return fav_prod(image_path:list[index]['imageurl'][0], rating:list[index]['rating'], reviews:list[index]['numreviews'], designer:list[index]['brand'], item:list[index]['name'], original_price:list[index]['price'], isnew:list[index]['isnew'],docid: list[index].id,);
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // here we can manage how the items in the grid will look, 2 items per row, with aspect ratio(size) and space between then and space between the current row and other rows
                            crossAxisCount: 2,
                            childAspectRatio: 0.5,
                            crossAxisSpacing: 70,
                          ),
                      ),
                        ),
                  ],
                    );
                  }
                }
              ),
              SizedBox(height: 10.0,),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('sale_product').where('favourite',arrayContains: FirebaseAuth.instance.currentUser.uid).snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }
                    else if(snapshot.connectionState==ConnectionState.waiting){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                    }else if(snapshot.data.size==0){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.5,child:
                      Center(child: Text('You have no favourites from sale products',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                    }else{
                      final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                      return Column(
                        children:<Widget>[
                          Center(child: Text('Favourite Sale Products',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),),
                          SizedBox(height: 10.0,),
                          SizedBox(
                            height: 300.0,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: list.length,
                              itemBuilder: (context,index){
                                return fav_sale_prod(image_path:list[index]['imageurl'][0], rating:list[index]['rating'], reviews:list[index]['numreviews'], designer:list[index]['brand'], item:list[index]['name'], original_price:list[index]['realprice'],sale_price: list[index]['saleprice'],sale: list[index]['salepercent'],docid: list[index].id);
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // here we can manage how the items in the grid will look, 2 items per row, with aspect ratio(size) and space between then and space between the current row and other rows
                                crossAxisCount: 2,
                                childAspectRatio: 0.5,
                                crossAxisSpacing: 70,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
