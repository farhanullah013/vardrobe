import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Services/url_short.dart';
import 'package:vardrobe/Screens/navigation_screen.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Screens/arproductscreen.dart';

class ar_vr_screen extends StatefulWidget {
  @override
  ar_vr_screenState createState() => ar_vr_screenState();
}

class ar_vr_screenState extends State<ar_vr_screen> {
  ArsProgressDialog _progressDialog;
  @override
  Widget build(BuildContext context) {
    _progressDialog=ArsProgressDialog(
        context,blur:2,
        backgroundColor:  Color(0x33000000),
        dismissable: false,
        loadingWidget:  Container(
          width: 100,
          height: 100,
          color: Colors.transparent,
          child: SpinKitPouringHourglass(
            color:Colors.amber,
            size: 100.0,
          ),
        ));
    return WillPopScope(
      onWillPop: ()async{
       return Navigator.push(context, PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
            },
            pageBuilder: (BuildContext  context, Animation<double> animation, Animation<double> secondaryAnimation){
              return navigation_screen();
            }
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:const Color.fromRGBO(30, 31, 40, 0.9) ,
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,size: 20.0,),
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
          title: Text("Virtual Try-on",style: TextStyle(fontFamily: kfontfamily,fontSize: 26.0),),
          actions: FirebaseAuth.instance.currentUser!=null?<Widget>[
            Center(child: Text("AR=",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),)),
            IconButton(onPressed: (){
              Navigator.push(context, PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
              },
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
              return arproductscreen();
              }
              ));
            }, icon: Icon(FontAwesomeIcons.mobile,color: Colors.white54,),tooltip: "AR",),
          ]:[],
        ),
        body: Provider.of<authenticationanduserprovider>(context).isloggedin()==true?SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0,top: 10.0),
            child: Column(
              children:<Widget>[
              SizedBox(
              height: MediaQuery.of(context).size.height/1.3,
              child: FutureBuilder<QuerySnapshot>(
                  future:FirebaseFirestore.instance.collection('products').where("vr",isEqualTo: true).get(),
                  builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }
                    else if(snapshot.connectionState==ConnectionState.waiting){
                      return Row(mainAxisAlignment: MainAxisAlignment.center,children:<Widget>[
                        SizedBox(height:80.0,width:80.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))]);
                    }else{
                      final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: list.length,
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: () async {
                              _progressDialog.show();
                              String link=await short.shortner(list[index]['arimage'],list[index].id);
                              _progressDialog.dismiss();
                              showModalBottomSheet(
                                backgroundColor:const Color.fromRGBO(30, 31, 40, 1.0) ,
                                isScrollControlled: true,
                                  context: context,
                                  builder: (context)=>Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(30, 31, 40, 1.0),
                                      image: DecorationImage(
                                        image: NetworkImage(link),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                              );
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
                                        image: NetworkImage(list[index]['arimage']),
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
                                        initialRating: list[index]['rating'].toDouble(),
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
                                        child: Text('('+'${list[index]['numreviews']}'+')',style: TextStyle(color: Colors.grey,fontSize: 13.0,fontFamily: kfontfamily,),) ,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height:3.0),
                                Container(
                                  child: Text('${list[index]['name']}',style: TextStyle(color: Colors.white,fontSize: 20.0,fontFamily: kfontfamily)) ,
                                ),
                                SizedBox(height:3.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:<Widget> [
                                    Text("\$"+'${list[index]['price']}',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 15.0,fontFamily: kfontfamily,),),
                                    SizedBox(width:2.0),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // here we can manage how the items in the grid will look, 2 items per row, with aspect ratio(size) and space between then and space between the current row and other rows
                          crossAxisCount: 2,
                          crossAxisSpacing: 70,
                          childAspectRatio: 0.5,
                          mainAxisSpacing: 10.0
                          //mainAxisSpacing: 100.0,
                        ),
                      );
                    }
                  }
              ),
            ),
              ],
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
