import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';

import 'constants.dart';

class address_widget extends StatefulWidget {
  final String addresstype;

  address_widget({this.addresstype});

  @override
  _address_widgetState createState() => _address_widgetState();
}

class _address_widgetState extends State<address_widget> {
  final _form=GlobalKey<FormState>();
  TextEditingController _address=TextEditingController();

  bool _saveform(){
    final isvalid=_form.currentState.validate();
    if(!isvalid){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(widget.addresstype,style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
        const SizedBox(width: 8.0),
        GestureDetector(
          child: Text("Change",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,color: Color(0xffEF3651)),
          ),
          onTap: (){
            showModalBottomSheet(
              context: context,
              builder:(context)=>Container(
                decoration: BoxDecoration(
                    color:const  Color.fromRGBO(30, 31, 40, 1.0),
                    borderRadius: BorderRadius.only(topRight:Radius.circular(35.0) ,topLeft: Radius.circular(35.0),)
                ),
                child: SingleChildScrollView(
                  child: StatefulBuilder(
                    builder: (BuildContext con,StateSetter state){
                      return Padding(
                        padding: EdgeInsets.only(top: 10.0,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:<Widget> [
                            const SizedBox(height: 10.0,),
                            Text("Please enter new address",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                            const SizedBox(height: 40.0,),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0,right: 15.0),
                              child: Form(
                                key: _form,
                                child: TextFormField(
                                  validator: (text){
                                    if(text.isEmpty){
                                      return 'Shipping address cannot be empty';
                                    }
                                    else if(text.length<6){
                                      return "Shipping address cannot be less than 6 characters";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.streetAddress,
                                  controller: _address,
                                  maxLength: 80,
                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                  decoration: InputDecoration(
                                    counter: Offstage(),
                                    filled: true,
                                    fillColor: Color(0xff2A2C36),
                                    hintText: 'Your address here',
                                    hintStyle: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: kfontfamily,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xff2A2C36), width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red, width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 90.0,),
                            Padding(
                              padding: EdgeInsets.only(left: 100.0,right: 100.0),
                              child: Container(
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
                                height: 50.0,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      primary: Color(0xffEF3651)
                                  ),
                                  onPressed: (){
                                    bool proceed=_saveform();
                                    if(proceed==true){
                                      if(widget.addresstype=="Shipping address"){
                                        Provider.of<authenticationanduserprovider>(context,listen: false).updateshipaddress(_address.text);
                                        Navigator.pop(context);
                                        Toast.show("Address Updated", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                      }else{
                                        Provider.of<authenticationanduserprovider>(context,listen: false).updatebilladdress(_address.text);
                                        Navigator.pop(context);
                                        Toast.show("Address Updated", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                      }
                                    }else{
                                      Toast.show("Please enter valid values", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                    }
                                  },
                                  child: Text("Update",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0,),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}