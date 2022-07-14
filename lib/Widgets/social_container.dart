import 'package:flutter/material.dart';

class social_container extends StatelessWidget {
  final String path;
  const social_container({this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: 100.0,
      child: Image.asset(path),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
