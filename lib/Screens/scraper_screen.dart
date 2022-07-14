import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Widgets/constants.dart';
//import 'file:///D:/VARDROBE/vardrobe/lib/Services/scraper.dart';
import 'package:url_launcher/url_launcher.dart';

class scraper_screen extends StatefulWidget {
  final String keyword;

  const scraper_screen({this.keyword});
  @override
  _scraper_screenState createState() => _scraper_screenState();
}

class _scraper_screenState extends State<scraper_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,size: 22.0,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 1.0,
        backgroundColor:const  Color.fromRGBO(30, 31, 40, 1.0),
        title: Text(widget.keyword,style: TextStyle(fontFamily: kfontfamily,fontSize: 30.0),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0),
          child: Column(
            children:<Widget> [
              Center(child: Text("Products from other platforms",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)),
              SizedBox(height: 20.0,),
              FutureBuilder<Map<String, dynamic>>(
                  //future:scrape.scrapeProducts(widget.keyword),
                  builder: (BuildContext con,snapshot){
                    if(snapshot.hasError){
                      print(snapshot.error);
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:double.infinity,height:70.0,child: Text("Something went wrong, please try again",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),))));
                    }else if(snapshot.connectionState==ConnectionState.waiting){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:70.0,height:70.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                    }else{
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height/1.4,
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.keys.length,
                          itemBuilder: (context,index){
                            double ratingconv;
                            double price;
                            ratingconv=double.parse(snapshot.data["$index"]["ratings"]);
                            price=double.parse(snapshot.data["$index"]["offered_price"]);
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
                                          image: NetworkImage(snapshot.data["$index"]["image_url"]),
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
                                          initialRating:ratingconv,
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
                                      price<0.0?Text("\$"+'1',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 16.0,fontFamily: kfontfamily,),):
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
