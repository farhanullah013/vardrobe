import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Widgets/category.dart';
import 'package:vardrobe/Widgets/constants.dart';

class category_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 31, 40, 1.0),
      appBar: AppBar(
        title: Text("Categories",style: TextStyle(fontFamily: kfontfamily,fontSize: 24.0),),
        centerTitle: true,
        elevation: 8.0,
        backgroundColor:const  Color.fromRGBO(30, 31, 40, 0.8),
        leading:IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0,left: 13.0,right: 13.0),
          child: SingleChildScrollView(
            child: Column(
              children:<Widget> [
                category(categorypath: "Assets/images/clothes.jpg",categoryname: "Clothes",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/shoes.jpg",categoryname: "Shoes",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/cosmetics.jpg",categoryname: "Cosmetics",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/sports.jpg",categoryname: "Sports",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/electronics.jpg",categoryname: "Electronics",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/watches.jpg",categoryname: "Watches",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/furniture.jpg",categoryname: "Furniture",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/videogames.jpg",categoryname: "Video games",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/jewel.jpg",categoryname: "Jewellery",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/toys.jpg",categoryname: "Toys",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/smart.jpg",categoryname: "Smartphones",),
                SizedBox(height: 15.0,),
                category(categorypath: "Assets/images/books.jpg",categoryname: "Books",),
                SizedBox(height: 15.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
