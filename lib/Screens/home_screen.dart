import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vardrobe/Screens/favourites_screen.dart';
import 'package:vardrobe/Screens/login_screen.dart';
import 'package:vardrobe/Screens/search_screen.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Services/best_seller.dart';
import 'package:vardrobe/Widgets/category_item.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:vardrobe/Widgets/sale_product.dart';
import 'package:vardrobe/Widgets/new_product.dart';
//import 'file:///D:/VARDROBE/vardrobe/lib/Services/scraper.dart';


import 'category_screen.dart';
class home_screen extends StatefulWidget {
  @override
  _home_screenState createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async{
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 8.0,
          automaticallyImplyLeading: false,
          backgroundColor:const  Color.fromRGBO(30, 31, 40, 0.8),
          title: GestureDetector(
            onTap: (){
              Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                    return search_screen();
                  }
              ));
            },
            child: Container(
              //margin: EdgeInsets.only(right: 40.0),
              height: 44.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.blueGrey.withOpacity(0.2),
              ),
              child: Row(
                children: <Widget>[
                  const  SizedBox(width: 10.0,),
                  Icon(FontAwesomeIcons.search,size: 19.0,color: Colors.grey.withOpacity(0.6),),
                  SizedBox(width: 9.0,),
                  Text("T-Shirts",style: TextStyle(fontSize: 15.0,fontFamily: kfontfamily,color: Colors.grey.withOpacity(0.6)),)
                ],
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon:Icon(
                  FontAwesomeIcons.heart,
                  color: Colors.white,
                ),
              onPressed: (){
                Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true?Navigator.push(context, PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                      return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                    },
                    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                      return favourites_screen();
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
            ),
          ],
        ),
        body:  SingleChildScrollView(
          child: Container(
            padding:const EdgeInsets.only(left: 12.0,top: 10.0) ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                SizedBox(
                height: 90.0,
                child: ListView(
                  scrollDirection:Axis.horizontal ,
                  children:<Widget>[
                    category_item(image_path:'Assets/images/pomade.jpg',text:'Cosmetics'),
                    const SizedBox(width:15.0),
                    category_item(image_path:'Assets/images/tshirt.png',text:'T-shirt'),
                    const SizedBox(width:15.0),
                    category_item(image_path:'Assets/images/electronics.png',text:'Electronics'),
                    const SizedBox(width:15.0),
                    category_item(image_path:'Assets/images/furniture.png',text:'Furniture'),
                    const SizedBox(width:15.0),
                    category_item(image_path:'Assets/images/jeans.png',text:'Jeans'),
                    const SizedBox(width:15.0),
                    category_item(image_path:'Assets/images/sports.png',text:'Sports'),
                    const SizedBox(width:15.0),
                    category_item(image_path:'Assets/images/watches.png',text:'Watches'),
                    const SizedBox(width:15.0),
                    Padding(padding:const  EdgeInsets.only(right: 5.0),child: Center(child: GestureDetector(child: Text('View All',style: TextStyle(fontFamily: kfontfamily,color: Colors.pink),),onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                            return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                          },
                          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                            return category_screen();
                          }
                      ));
                    },),
                    ),
                    )
                  ],
                ),
                  ),
                const  SizedBox(height:18.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                      ),
                      height: 200.0,
                      child: FutureBuilder<DocumentSnapshot>(
                          future:FirebaseFirestore.instance.collection('banners').doc('JTSmZOp9yopmfcmSjNqT').get(),
                          builder: (BuildContext con,AsyncSnapshot<DocumentSnapshot>snapshot){
                            if(snapshot.hasError){
                              return Text("Something went wrong",style: TextStyle(fontFamily: kfontfamily),);
                            }else if(snapshot.connectionState==ConnectionState.done){
                              Map<String,dynamic> data=snapshot.data.data();
                              List<String> banlinks = new List<String>.from(data.values.first);
                              List<Widget> bannerwidgets=[];
                              banlinks.forEach((element) {
                                bannerwidgets.add(CachedNetworkImage(imageUrl: element,fit: BoxFit.fill,filterQuality: FilterQuality.medium,));
                              });
                              return Carousel(
                                  autoplay: false,
                                  animationCurve: Curves.fastOutSlowIn,
                                  animationDuration: const Duration(milliseconds: 1000),
                                  dotSize: 6.0,
                                  dotIncreasedColor: const Color(0xFFFF335C),
                                  dotColor: Colors.white,
                                  dotBgColor: Colors.transparent,
                                  dotPosition: DotPosition.bottomCenter,
                                  dotVerticalPadding: 10.0,
                                  indicatorBgPadding: 7.0,
                                  images:bannerwidgets
                              );
                            }else{
                              return Row(mainAxisAlignment: MainAxisAlignment.center,children:<Widget>[
                                SizedBox(height:80.0,width:80.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))]);
                            }
                          }
                      ),
                    ),
                  ),
                const  SizedBox(height:16.0),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget> [
                      Container(
                        child: Text('Sale',style: TextStyle(fontSize: 40.0,fontFamily: 'Nunito-Bold'),),
                      ),
                      Container(
                        child: Text('View all',style: TextStyle(fontSize: 14.0,fontFamily: kfontfamily),),
                      )
                    ],
                  ),
                ),
                Container(
                  child:Text('Super summer sale',style: TextStyle(fontSize: 14.0,fontFamily: kfontfamily),),
                ),
                const SizedBox(height:17.0),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 320.0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection('sale_product').snapshots(),
                      builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
                        if(snapshot.hasError){
                          return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                        }
                        else if(snapshot.connectionState==ConnectionState.waiting){
                          return Row(mainAxisAlignment: MainAxisAlignment.center,children:<Widget>[
                            SizedBox(height:80.0,width:80.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))]);
                        }else{
                          final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                          return ListView.separated(
                            separatorBuilder: (context,_){
                              return const  SizedBox(width:15.0);
                            },
                            itemCount: list.length,
                            scrollDirection:Axis.horizontal ,
                            itemBuilder: (context,index){
                              return sale_product(sale: list[index]['salepercent'],image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                                designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['realprice'],sale_price: list[index]['saleprice'],rating: list[index]['rating'],docid: list[index].id,
                                favourites: list[index]['favourite'],);
                            },
                          );
                        }
                      }
                    ),
                  ),
                ),
                const  SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget> [
                      Container(
                        child: Text('New',style: TextStyle(fontSize: 40.0,fontFamily: 'Nunito-Bold'),),
                      ),
                      Container(
                        child: Text('View all',style: TextStyle(fontSize: 14.0,fontFamily: kfontfamily),),
                      )
                    ],
                  ),
                ),
                Container(
                  child:Text('You\'ve never seen it before',style: TextStyle(fontSize: 14.0,fontFamily: kfontfamily),),
                ),
                const SizedBox(height:17.0),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 330.0,
                    child: StreamBuilder<QuerySnapshot>(
                        stream:FirebaseFirestore.instance.collection('products').snapshots(),
                        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
                          if(snapshot.hasError){
                            return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                          }
                          else if(snapshot.connectionState==ConnectionState.waiting){
                            return Row(mainAxisAlignment: MainAxisAlignment.center,children:<Widget>[
                              SizedBox(height:80.0,width:80.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))]);
                          }else{
                            final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                            return ListView.separated(
                              separatorBuilder: (context,_){
                                return const  SizedBox(width:15.0);
                              },
                              itemCount: list.length,
                              scrollDirection:Axis.horizontal ,
                              itemBuilder: (context,index){
                                return new_product(image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                                  designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['price'],rating: list[index]['rating'],isnew: list[index]['isnew'],docid: list[index].id,favourites: list[index]['favourite']);
                              },
                            );
                          }
                        }
                    ),
                  ),
                ),
                const SizedBox(height:17.0),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget> [
                      Container(
                        child: Text('Best Sellers',style: TextStyle(fontSize: 40.0,fontFamily: 'Nunito-Bold'),),
                      ),
                      Container(
                        child: Text('View all',style: TextStyle(fontSize: 14.0,fontFamily: kfontfamily),),
                      )
                    ],
                  ),
                ),
                Container(
                  child:Text('Grab one quick!',style: TextStyle(fontSize: 14.0,fontFamily: kfontfamily),),
                ),
                const SizedBox(height:17.0),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 330.0,
                    child: StreamBuilder<List<QueryDocumentSnapshot>>(
                        stream:best_seller().products.asStream(),
                        builder: (context,AsyncSnapshot<List<QueryDocumentSnapshot>>snapshot){
                          if(snapshot.hasError){
                            return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                          }
                          else if(snapshot.connectionState==ConnectionState.waiting){
                            return Row(mainAxisAlignment: MainAxisAlignment.center,children:<Widget>[
                              SizedBox(height:80.0,width:80.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))]);
                          }else{
                            final List<QueryDocumentSnapshot> list=snapshot.data;
                            return ListView.separated(
                              separatorBuilder: (context,_){
                                return const  SizedBox(width:15.0);
                              },
                              itemCount: list.length,
                              scrollDirection:Axis.horizontal ,
                              itemBuilder: (context,index){
                                return new_product(image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                                  designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['price'],rating: list[index]['rating'],isnew: list[index]['isnew'],docid: list[index].id,favourites: list[index]['favourite']);
                              },
                            );
                          }
                        }
                    ),
                  ),
                ),
                const SizedBox(height:17.0),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 330.0,
                    child: StreamBuilder<List<QueryDocumentSnapshot>>(
                        stream:best_seller().sale_products.asStream(),
                        builder: (context,AsyncSnapshot<List<QueryDocumentSnapshot>>snapshot){
                          if(snapshot.hasError){
                            return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                          }
                          else if(snapshot.connectionState==ConnectionState.waiting){
                            return Row(mainAxisAlignment: MainAxisAlignment.center,children:<Widget>[
                              SizedBox(height:80.0,width:80.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))]);
                          }else{
                            final List<QueryDocumentSnapshot> list=snapshot.data;
                            return ListView.separated(
                              separatorBuilder: (context,_){
                                return const  SizedBox(width:15.0);
                              },
                              itemCount: list.length,
                              scrollDirection:Axis.horizontal ,
                              itemBuilder: (context,index){
                                return sale_product(sale: list[index]['salepercent'],image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                                  designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['realprice'],sale_price: list[index]['saleprice'],rating: list[index]['rating'],docid: list[index].id,favourites: list[index]['favourite']);
                              },
                            );
                          }
                        }
                    ),
                  ),
                ),
                const SizedBox(height:50.0),
                SizedBox(
                  height: 300.0,
                  child: StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection('products').snapshots(),
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
                            shrinkWrap: false,
                            scrollDirection: Axis.vertical,
                            itemCount: list.length,
                            itemBuilder: (context,index){
                              return new_product(image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                                designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['price'],rating: list[index]['rating'],isnew: list[index]['isnew'],docid: list[index].id,favourites: list[index]['favourite']);
                          },
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // here we can manage how the items in the grid will look, 2 items per row, with aspect ratio(size) and space between then and space between the current row and other rows
                                crossAxisCount: 2,
                                childAspectRatio: 0.46,
                                crossAxisSpacing: 70,
                            ),
                          );
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}