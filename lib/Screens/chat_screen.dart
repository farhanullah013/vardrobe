import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Widgets/message_bubble.dart';

class chat_screen extends StatefulWidget {
  final String prodid;
  final String vendor;
  const chat_screen({this.prodid, this.vendor});
  @override
  _chat_screenState createState() => _chat_screenState();
}

class _chat_screenState extends State<chat_screen> {

  TextEditingController _messageediting=TextEditingController();

  final _form=GlobalKey<FormState>();

  bool _saveform(){
    final isvalid=_form.currentState.validate();
    if(!isvalid){
      return false;
    }
    return true;
  }
  
  String chatdocid;
  
  Future<void> _chat() async {
    QuerySnapshot qs=await FirebaseFirestore.instance.collection('chats').where('productid',isEqualTo: widget.prodid).where('userid',isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    if(qs.docs.length==0){
      DocumentReference dr=await FirebaseFirestore.instance.collection('chats').add({
        'productid':widget.prodid,
        'userid':FirebaseAuth.instance.currentUser.uid,
      });
      await FirebaseFirestore.instance.collection('chats').doc(dr.id).collection('messages').add({
        'sender':'dummy',
        'text':'dummy',
        'datetime':DateTime.now()
      });
      QuerySnapshot qs1=await FirebaseFirestore.instance.collection('chats').where('productid',isEqualTo: widget.prodid).where('userid',isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
      setState(() {
        chatdocid=qs1.docs.first.id;
      });
    }else{
      setState(() {
        chatdocid=qs.docs.first.id;
      });
    }
  }
@override
  void initState() {
    _chat();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 31, 40, 0.9),
      appBar: AppBar(
        title: Text(widget.vendor,style: TextStyle(fontFamily: kfontfamily,fontSize:25.0 ),),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: const  Color.fromRGBO(30, 31, 40, 0.8),
      ),
      body: Padding(
        padding: EdgeInsets.only(left:10.0 ,right: 10.0,bottom: 15.0),
        child: Column(
          children:<Widget> [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('chats').doc(chatdocid).collection('messages').orderBy('datetime').snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }else if(snapshot.connectionState==ConnectionState.waiting){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                    }else if(snapshot.data.docs.length==0||snapshot.data.docs.length==1){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:100.0,height:100.0,child: Text('Get started!',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),))));
                    }
                    else{
                      List<QueryDocumentSnapshot> data=snapshot.data.docs;
                      data.removeAt(0);
                     String email= FirebaseAuth.instance.currentUser.email;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.separated(
                          separatorBuilder: (context,_){
                            return const  SizedBox(height:15.0);
                          },
                          itemCount: data.length,
                          scrollDirection:Axis.vertical ,
                          itemBuilder: (context,index){
                            return message_bubble(text:data[index]['text'],isme:email==data[index]['sender']?true:false,sender:data[index]['sender']);
                          },
                        ),
                      );
                    }
                  }
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 7.0),
                    child: Form(
                      key: _form,
                      child: TextFormField(
                        controller: _messageediting,
                        maxLength: 100,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        validator: (text)=>text.isNotEmpty?null:"Message cannot be empty",
                        decoration: InputDecoration(
                          counter: Offstage(),
                          filled: true,
                          fillColor: Color(0xff2A2C36),
                          hintText: 'Your message',
                          hintStyle: TextStyle(
                              fontSize: 15.0,
                              fontFamily: kfontfamily,
                              color: Colors.white
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xff2A2C36), width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.paperPlane,color: Colors.white,size: 25.0,),
                  onPressed: () async {
                    bool proceed=_saveform();
                    if(proceed==true){
                      await FirebaseFirestore.instance.collection('chats').doc(chatdocid).collection('messages').add({
                        'text':_messageediting.text,
                        'sender':FirebaseAuth.instance.currentUser.email,
                        'datetime':DateTime.now()
                      });
                      _messageediting.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
