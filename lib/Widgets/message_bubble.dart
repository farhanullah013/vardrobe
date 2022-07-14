import 'package:flutter/material.dart';
import 'package:vardrobe/Widgets/constants.dart';

class message_bubble extends StatelessWidget {
  final String text;
  final bool isme;
  final String sender;
  message_bubble({this.text,this.isme,this.sender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isme?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children:<Widget>[
          Text(sender,style: TextStyle(fontSize: 12.0,color: Colors.white,fontFamily: kfontfamily),),
          Material(
            borderRadius: isme?BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)):BorderRadius.only(bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),topRight: Radius.circular(30.0)),
            elevation: 5.0,
            color:/* getcolor()*/ isme ? Colors.lightBlueAccent.withOpacity(0.2) :Colors.white ,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0 ),
              child: Text(text,
                style: TextStyle(
                    color: isme ? Colors.white:Colors.black54,
                    fontSize: 15.0,fontFamily: kfontfamily
                ),
              ),
            ),
          ),],
      ),
    );
  }
}
