import 'dart:io';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:vardrobe/Screens/profile_pic_screen.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';

class edit_profile extends StatefulWidget {
  @override
  _edit_profileState createState() => _edit_profileState();
}

class _edit_profileState extends State<edit_profile> {
  final _form=GlobalKey<FormState>();
  final _form2=GlobalKey<FormState>();

  ArsProgressDialog _progressDialog;

  TextEditingController _nametext=TextEditingController();
  TextEditingController _currentpass=TextEditingController();
  TextEditingController _newpass=TextEditingController();
  TextEditingController _connewpass=TextEditingController();

  bool _saveform(){
    final isvalid=_form.currentState.validate();
    if(!isvalid){
      return false;
    }
    return true;
  }
  bool _saveform2(){
    final isvalid=_form2.currentState.validate();
    if(!isvalid){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog=ArsProgressDialog(
        context,blur:2,
        backgroundColor:  Color(0x33000000),
        loadingWidget:  Container(
          width: 150,
          height: 150,
          color: Colors.transparent,
          child: SpinKitPouringHourglass(
            color:Colors.amber,
            size: 150.0,
          ),
        ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromRGBO(30, 31, 40, 0.8),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left:15.0 ,right: 15.0,top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Settings",style: TextStyle(fontSize:30.0 ,fontFamily: kfontfamily),),
              const SizedBox(height: 10.0,),
              Text("Personal Information",style: TextStyle(fontSize:18.0 ,fontFamily: kfontfamily),),
              const SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Name",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,),),
                  GestureDetector(
                      child: Text("Change",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Color(0xffEF3651)),),
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
                                      Text("Enter your name",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                      const SizedBox(height: 40.0,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                        child: Form(
                                          key: _form,
                                          child: TextFormField(
                                            controller: _nametext,
                                            validator: (text){
                                              if(text.isEmpty){
                                                return 'Name cant be empty';
                                              }else if(!text.contains(new RegExp(r'^[A-Za-z ]+$'))){
                                                return "Only alphabets allowed";
                                              }
                                              else if(text.length<6){
                                                return "Name cannot be less than 6 characters";
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.streetAddress,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xff2A2C36),
                                              hintText: 'Your name here',
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
                                            onPressed: () async{
                                              bool proceed=_saveform();
                                              if(proceed==true){
                                                bool verif=await Provider.of<authenticationanduserprovider>(context,listen: false).updateusername(_nametext.text);
                                                if(verif==true){
                                                  Navigator.pop(context);
                                                  Toast.show("Name Updated", context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                                                }else{
                                                  Toast.show(authenticationanduserprovider.message, context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                                }
                                              }
                                            },
                                            child: Text("Update",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15.0,),
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
              ),
              const SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff2A2C36),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: StreamBuilder<usser>(stream: authenticationanduserprovider().userdata,
                  builder:(context,snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }else if(snapshot.connectionState==ConnectionState.waiting){
                      return Text('Loading',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }
                    else{
                      return Text(snapshot.data.name,style: TextStyle(fontSize:18.0 ,fontFamily: kfontfamily,color: Colors.grey));
                    }
                  },),
              ),
              const SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Date of Birth",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,),),
                  GestureDetector(
                      child: Text("Change",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Color(0xffEF3651)),),
                    onTap: (){
                      DatePicker.showDatePicker(
                          context,
                          theme: DatePickerTheme(
                            backgroundColor: Colors.grey.withOpacity(1.0),
                            doneStyle: TextStyle(color: Color(0xffEF3651))
                          ),
                          showTitleActions: true,
                          minTime: DateTime(1950, 3, 5),
                          maxTime: DateTime(2021, 4, 31),
                         onConfirm: (date)async {
                           bool verif=await Provider.of<authenticationanduserprovider>(context,listen: false).updatedob(date);
                           if(verif==true){
                             Toast.show("Name Updated", context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                           }else{
                             Toast.show(authenticationanduserprovider.message, context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                           }
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.en);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff2A2C36),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: StreamBuilder<usser>(stream: authenticationanduserprovider().userdata,
                  builder:(context,snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }else if(snapshot.connectionState==ConnectionState.waiting){
                      return Text('Loading',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }
                    else{
                      return Text(snapshot.data.dateofbirth.toString().substring(0,10),style: TextStyle(fontSize:18.0 ,fontFamily: kfontfamily,color: Colors.grey));
                    }
                  },)
              ),
              const SizedBox(height: 50.0,),
              Provider.of<authenticationanduserprovider>(context,listen: false).providertype()=="password"?Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Password",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,),),
                  GestureDetector(
                      child: Text("Change",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Color(0xffEF3651)),),
                    onTap: (){
                      showModalBottomSheet(
                        context: context,
                        builder:(context)=>Container(
                          decoration: BoxDecoration(
                              color:const  Color.fromRGBO(30, 31, 40, 1.0),
                              borderRadius: BorderRadius.only(topRight:Radius.circular(35.0) ,topLeft: Radius.circular(35.0),)
                          ),
                          child: StatefulBuilder(
                            builder: (BuildContext con,StateSetter state){
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.0,),
                                  child: Form(
                                    key: _form2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:<Widget> [
                                        const SizedBox(height: 10.0,),
                                        Text("Please enter current password",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                        const SizedBox(height: 20.0,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                          child: TextFormField(
                                            controller: _currentpass,
                                            validator: (text){
                                              if(text.isEmpty){
                                                return 'Current password cannot be empty';
                                              }else if(text.length<=6){
                                                return 'Current Password has to be more than 6 characters long';
                                              }else{
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.streetAddress,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xff2A2C36),
                                              hintText: '',
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
                                        const SizedBox(height: 20.0,),
                                        Text("Please enter new password",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                        const SizedBox(height: 20.0,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                          child: TextFormField(
                                            controller: _newpass,
                                            validator: (text){
                                              if(text.isEmpty){
                                                return 'Password cannot be empty';
                                              }else if(text.length<=6){
                                                return 'Password has to be more than 6 characters long';
                                              }else if(text.length>20){
                                                return 'Password has to be less than 20 characters long';
                                              }
                                              else{
                                                return null;
                                              }
                                            },
                                            keyboardType: TextInputType.streetAddress,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xff2A2C36),
                                              hintText: '',
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
                                        const SizedBox(height: 20.0,),
                                        Text("Confirm new password",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                        const SizedBox(height: 20.0,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                          child: TextFormField(
                                            controller: _connewpass,
                                            keyboardType: TextInputType.streetAddress,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xff2A2C36),
                                              hintText: '',
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
                                        const SizedBox(height: 70.0,),
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
                                                primary: Color(0xffEF3651),
                                              ),
                                              onPressed: () async{
                                                bool proceed=_saveform2();
                                                if(_newpass.text!=_connewpass.text){
                                                  Toast.show("Passwords do not match", context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                                                }else if(_newpass.text==_connewpass.text && proceed==true){
                                                  await Provider.of<authenticationanduserprovider>(context,listen: false).updatepass(currentpass: _currentpass.text,pass: _newpass.text);
                                                  Navigator.pop(context);
                                                  Toast.show(authenticationanduserprovider.message, context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                                                }
                                              },
                                              child: Text("Update",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ):Container(),
              const SizedBox(height: 10.0,),
              Provider.of<authenticationanduserprovider>(context,listen: false).providertype()=="password"?Container(
                  padding: EdgeInsets.all(8.0),
                  height: 40.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff2A2C36),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Align(alignment:Alignment.centerLeft,child: Text('********'))
              ):Container(),
              const SizedBox(height: 25.0,),
              Text("Change profile picture",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,),),
              const SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  StreamBuilder<usser>(stream: authenticationanduserprovider().userdata,
                    builder:(context,snapshot){
                      if(snapshot.hasError){
                        return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                      }else if(snapshot.connectionState==ConnectionState.waiting){
                        return Text('Loading',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                      }
                      else{
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 600),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                  return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                  return profile_pic_screen();
                                }
                            ));
                          },
                            child: CircleAvatar(backgroundImage:NetworkImage(snapshot.data.profilepic),backgroundColor:Colors.grey,radius: 38.0,));
                      }
                    },),
                  const SizedBox(width: 10.0,),
                  GestureDetector(
                    onTap: () async{
                      _progressDialog.show();
                      await Provider.of<authenticationanduserprovider>(context,listen: false).updateprofilepic();
                      _progressDialog.dismiss();
                      Toast.show(authenticationanduserprovider.message, context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                    },
                      child: Text("Upload new",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Color(0xffEF3651)),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
