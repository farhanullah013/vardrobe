import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constants.dart';

class filtersandsort extends StatelessWidget {
  final String filtername;
  final IconData icontype;

  const filtersandsort({this.filtername, this.icontype});


  @override
  Widget build(BuildContext context) {
    return Row(
      children:<Widget> [
        Icon(icontype,color: Colors.white,size: 20.0,),
        SizedBox(width: 5.0,),
        Text(filtername,style: TextStyle(fontFamily: kfontfamily,fontSize:18.0 ),),
      ],
    );
  }
}