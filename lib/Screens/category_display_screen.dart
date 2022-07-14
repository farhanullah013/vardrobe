import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Widgets/new_product.dart';
import 'package:vardrobe/Widgets/sale_product.dart';

class category_display_screen extends StatelessWidget {
  final String cat;

  const category_display_screen({ this.cat});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat,style: TextStyle(fontFamily: kfontfamily,fontSize: 24.0),),
        centerTitle: true,
        elevation: 5.0,
        backgroundColor:const  Color.fromRGBO(30, 31, 40, 0.9),
        leading:IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
          child: Column(
            children: <Widget>[
              FutureBuilder<QuerySnapshot>(
                future:FirebaseFirestore.instance.collection('products').where('category',arrayContainsAny: [cat.toLowerCase()]).get(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasError){
                    return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                  }else if(snapshot.connectionState==ConnectionState.waiting){
                    return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                    Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                  }else if(snapshot.data.docs.length==0){
                    return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                    Center(child: Text('No products currently available',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                  }else{
                    final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height/3,
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: list.length,
                        itemBuilder: (context,index){
                          return new_product(image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                              designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['price'],rating: list[index]['rating'],isnew: list[index]['isnew'],docid: list[index].id,favourites: list[index]['favourite']);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.5,
                          crossAxisSpacing: 70,
                        ),
                      ),
                    );
                  }
                }
              ),
              SizedBox(height: 30.0,),
              FutureBuilder<QuerySnapshot>(
                  future:FirebaseFirestore.instance.collection('sale_product').where('category',arrayContainsAny: [cat.toLowerCase()]).get(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }else if(snapshot.connectionState==ConnectionState.waiting){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                    }else if(snapshot.data.docs.length==0){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: Text('No sale products currently available',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                    }else{
                      final List<QueryDocumentSnapshot> list=snapshot.data.docs;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height/2.5,
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: list.length,
                          itemBuilder: (context,index){
                            return sale_product(sale: list[index]['salepercent'],image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                                designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['realprice'],sale_price: list[index]['saleprice'],rating: list[index]['rating'],docid: list[index].id,favourites: list[index]['favourite']);
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.5,
                            crossAxisSpacing: 70,
                          ),
                        ),
                      );
                    }
                  }
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
