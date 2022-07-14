import 'package:flutter/material.dart';

import 'constants.dart';

class roundbutton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  const roundbutton({ this.text, this.callback});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ]
      ),
      height: 55.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
          primary: Color(0xffEF3651),
        ),
        onPressed: callback,
        child: Text(text,style: TextStyle(fontSize: 20.0,fontFamily: kfontfamily),),
      ),
    );
  }
}