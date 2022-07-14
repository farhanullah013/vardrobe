import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Widgets/constants.dart';

class product_image_screen extends StatefulWidget {
  final List<Widget> prodimage;

  const product_image_screen({ this.prodimage});

  @override
  _product_image_screenState createState() => _product_image_screenState();
}

class _product_image_screenState extends State<product_image_screen> {
  int _current=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.black12.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.times,color: Colors.white,size: 20.0,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("$_current/${widget.prodimage.length}",style: TextStyle(fontFamily: kfontfamily,fontSize:25.0),),
      ),
      backgroundColor: const Color.fromRGBO(30, 31, 40, 1.0),
      body: Center(
        child: Container(
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
            images: widget.prodimage,
            onImageChange: (pre,curr){
              setState(() {
                _current=curr+1;
              });
            },
          ),
        ),
      ),
    );
  }
}
