import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vardrobe/Widgets/constants.dart';

class profile_pic_screen extends StatefulWidget {

  @override
  _profile_pic_screenState createState() => _profile_pic_screenState();
}

class _profile_pic_screenState extends State<profile_pic_screen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(snapshot.hasError){
              return Text("Something went wrong",style: TextStyle(fontFamily: kfontfamily),);
            }else if(snapshot.connectionState==ConnectionState.done){
              Map<String, dynamic> data = snapshot.data.data();
              return Container(child: Center(child: Image(image: NetworkImage(data['profilepic']))));
            }else{
              return  CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,);
            }
          }
        ),
      ),
    );
  }
}
