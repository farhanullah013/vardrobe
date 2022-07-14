import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:vardrobe/Screens/edit_profile.dart';
import 'package:vardrobe/Screens/login_screen.dart';
import 'package:vardrobe/Screens/navigation_screen.dart';
import 'package:vardrobe/Screens/orders_screen.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Widgets/constants.dart';

class  account_screen extends StatefulWidget {
  @override
  _account_screenState createState() => _account_screenState();
}

class _account_screenState extends State<account_screen> {

  TextEditingController _shipaddress=TextEditingController();
  TextEditingController _billaddress=TextEditingController();

  final _form=GlobalKey<FormState>();
  final _form2=GlobalKey<FormState>();

  ArsProgressDialog _progressDialog;

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
  void dispose() {
    _shipaddress.dispose();
    _billaddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog=ArsProgressDialog(
        context,blur:2,
        backgroundColor:  Color(0x33000000),
        loadingWidget:  Container(
          width: 100,
          height: 100,
          color: Colors.transparent,
          child: SpinKitPouringHourglass(
            color:Colors.amber,
            size: 100.0,
          ),
        ));
    return WillPopScope(
      onWillPop: (){
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        return Navigator.push(context, PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
            },
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
              return navigation_screen();
            }
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:const Color.fromRGBO(30, 31, 40, 0.9),
          title: Text("My Account",style: TextStyle(fontFamily: kfontfamily,fontSize: 28.0),),
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
            onPressed: (){
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              return Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                    return navigation_screen();
                  }
              ));
            },
          ),
        ),
        body:SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top:25.0,left: 10.0,right: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children:<Widget> [
                    Provider.of<authenticationanduserprovider>(context).isloggedin()!=true?CircleAvatar(backgroundImage:AssetImage("Assets/images/notloggedin.png"),backgroundColor:Colors.grey,radius: 38.0,):
                    StreamBuilder<usser>(stream: authenticationanduserprovider().userdata,
                      builder:(context,snapshot){
                        if(snapshot.hasError){
                          return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                        }else if(snapshot.connectionState==ConnectionState.waiting){
                          return CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,);
                        }
                        else{
                          return CircleAvatar(backgroundImage:NetworkImage(snapshot.data.profilepic),backgroundColor:Colors.grey,radius: 38.0,);
                        }
                      },),
                    const SizedBox(width: 5.0,),
                    Column(
                      crossAxisAlignment: Provider.of<authenticationanduserprovider>(context).isloggedin()==true?CrossAxisAlignment.start:CrossAxisAlignment.center,
                      children:<Widget> [

                        Provider.of<authenticationanduserprovider>(context).isloggedin()==true?StreamBuilder<usser>(
                          stream: authenticationanduserprovider().userdata,
                          builder: (context,snapshot){
                            if(snapshot.hasError){
                              return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                            }
                            else if(snapshot.hasData){
                                return Text(snapshot.data.name,style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0));
                            }else{
                              return CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,);
                            }
                          },
                        ):
                        ElevatedButton(style:ElevatedButton.styleFrom(primary:Color(0xffEF3651),shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))  ),child: Text("Login",style: TextStyle(fontSize: 18.0,fontFamily: kfontfamily),),
                          onPressed: (){
                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          Navigator.push(context, PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                              },
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                return login_screen();
                              }
                          ));
                        },),
                        const SizedBox(height: 5.0,),
                        Text(Provider.of<authenticationanduserprovider>(context).isloggedin()==true?FirebaseAuth.instance.currentUser.email:"",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0,color: Colors.grey),),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child:Column(
                    children:<Widget>[
                      SizedBox(
                        height: 40.0,
                        child: ListTile(
                          title: Text("Edit Profile",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                          dense: true,
                          leading: Icon(FontAwesomeIcons.pencilAlt,size: 18.0,),
                          trailing: Icon(FontAwesomeIcons.chevronRight,color:Color(0xffEF3651),size: 16.0, ),
                          onTap: (){
                            Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true? Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 600),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                  return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                  return edit_profile();
                                }
                            )):Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 600),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                  return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                  return login_screen();
                                }
                            ));
                          },
                        ),
                      ),
                      Divider(
                        indent: 4.0,
                        endIndent: 4.0,
                        thickness: 1.0,
                        color: Color(0xffE72A28).withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ListTile(
                          title: Text("My Orders",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                          dense: true,
                          leading: Icon(FontAwesomeIcons.list,size: 18.0,),
                          trailing: Icon(FontAwesomeIcons.chevronRight,color:Color(0xffEF3651),size: 16.0, ),
                          onTap: (){
                            Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true?Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 600),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                  return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                  return orders_screen();
                                }
                            )):Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 600),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                  return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                  return login_screen();
                                }
                            ));
                          },
                          ),
                        ),
                      Divider(
                        indent: 4.0,
                        endIndent: 4.0,
                        thickness: 1.0,
                        color: Color(0xffE72A28).withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ListTile(
                          title: Text("Customer support",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                          dense: true,
                          leading: Icon(FontAwesomeIcons.headphones,size: 18.0,),
                          trailing:Icon(FontAwesomeIcons.chevronRight,color:Color(0xffEF3651),size: 16.0, ),
                        ),
                      ),
                      Divider(
                        indent: 4.0,
                        endIndent: 4.0,
                        thickness: 1.0,
                        color: Color(0xffE72A28).withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ListTile(
                          title: Text("Rate our app",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                          dense: true,
                          leading: Icon(FontAwesomeIcons.star,size: 18.0,),
                          trailing:Icon(FontAwesomeIcons.chevronRight,color:Color(0xffEF3651),size: 16.0, ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff2A2C36),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child:Column(
                    children:<Widget>[
                      SizedBox(
                        height: 40.0,
                        child: ListTile(
                          title: Text("Shipping address",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                          dense: true,
                          leading: Icon(FontAwesomeIcons.truck,size: 18.0,),
                          trailing: Icon(FontAwesomeIcons.chevronRight,color:Color(0xffEF3651),size: 16.0, ),
                          onTap: (){
                            Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true?showModalBottomSheet(
                              context: context,
                              builder:(context)=>SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:const  Color.fromRGBO(30, 31, 40, 1.0),
                                      borderRadius: BorderRadius.only(topRight:Radius.circular(35.0) ,topLeft: Radius.circular(35.0),)
                                  ),
                                  child: StatefulBuilder(
                                    builder: (BuildContext con,StateSetter state){
                                      return Padding(
                                        padding: EdgeInsets.only(top: 10.0,),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children:<Widget> [
                                            const SizedBox(height: 10.0,),
                                            Text("Your shipping address",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                            const SizedBox(height: 40.0,),
                                            Padding(
                                              padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                              child: Container(
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
                                                      return Text(snapshot.data.shippingaddress,style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey));
                                                    }
                                                  },)
                                              ),
                                            ),
                                            const SizedBox(height: 40.0,),
                                            Text("Enter new shipping address",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                            const SizedBox(height: 40.0,),
                                            Form(
                                              key: _form,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                                child: TextFormField(
                                                  maxLength: 80,
                                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                                  validator: (text){
                                                    if(text.isEmpty){
                                                      return 'Shipping address cannot be empty';
                                                    }
                                                    else if(text.length<6){
                                                      return "Shipping address cannot be less than 6 characters";
                                                    }
                                                    return null;
                                                  },
                                                  controller: _shipaddress,
                                                  keyboardType: TextInputType.streetAddress,
                                                  decoration: InputDecoration(
                                                    counterStyle: TextStyle(color: Color(0xffEF3651)),
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
                                            ),
                                            const SizedBox(height: 50.0,),
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
                                                  onPressed: ()async{
                                                    bool proceed=_saveform();
                                                    if(proceed==true){
                                                    await Provider.of<authenticationanduserprovider>(context,listen: false).updateshipaddress(_shipaddress.text);
                                                    _shipaddress.clear();
                                                    Navigator.pop(context);
                                                    Toast.show(authenticationanduserprovider.message, context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                                  }
                                                    },
                                                  child: Text("Update",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10.0,),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ):Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 600),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                  return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                  return login_screen();
                                }
                            ));
                          },
                        ),
                      ),
                      Divider(
                        indent: 4.0,
                        endIndent: 4.0,
                        thickness: 1.0,
                        color: Color(0xffE72A28).withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ListTile(
                          title: Text("Billing address",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                          dense: true,
                          leading: Icon(FontAwesomeIcons.moneyBillWave,size: 18.0,),
                          trailing: Icon(FontAwesomeIcons.chevronRight,color:Color(0xffEF3651),size: 16.0, ),
                          onTap: (){
                            Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true?
                            showModalBottomSheet(
                              context: context,
                              builder:(context)=>SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:const  Color.fromRGBO(30, 31, 40, 1.0),
                                      borderRadius: BorderRadius.only(topRight:Radius.circular(35.0) ,topLeft: Radius.circular(35.0),)
                                  ),
                                  child: StatefulBuilder(
                                    builder: (BuildContext con,StateSetter state){
                                      return Padding(
                                        padding: EdgeInsets.only(top: 10.0,),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children:<Widget> [
                                            const SizedBox(height: 10.0,),
                                            Text("Your billing address",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                            const SizedBox(height: 40.0,),
                                            Padding(
                                              padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                              child: Container(
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
                                                      return Text(snapshot.data.billingaddress,style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Colors.grey));
                                                    }
                                                  },)
                                              ),
                                            ),
                                            const SizedBox(height: 40.0,),
                                            Text("Enter new billing address",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                            const SizedBox(height: 40.0,),
                                            Form(
                                              key: _form2,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 15.0,right: 15.0),
                                                child: TextFormField(
                                                  maxLength: 80,
                                                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                                  validator: (text){
                                                    if(text.isEmpty){
                                                      return 'Shipping address cannot be empty';
                                                    }
                                                    else if(text.length<6){
                                                      return "Shipping address cannot be less than 6 characters";
                                                    }
                                                    return null;
                                                  },
                                                  controller: _billaddress,
                                                  keyboardType: TextInputType.streetAddress,
                                                  decoration: InputDecoration(
                                                    counterStyle: TextStyle(color: Color(0xffEF3651)),
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
                                                  onPressed: ()async{
                                                    bool proceed=_saveform2();
                                                    if(proceed==true){
                                                      await Provider.of<authenticationanduserprovider>(context,listen: false).updatebilladdress(_billaddress.text);
                                                      _billaddress.clear();
                                                      Navigator.pop(context);
                                                      Toast.show(authenticationanduserprovider.message, context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                                    }
                                                  },
                                                  child: Text("Update",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10.0,)
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ):Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                            return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                            },
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                            return login_screen();
                            }
                            ));
                          },
                        ),
                      ),
                      Divider(
                        indent: 4.0,
                        endIndent: 4.0,
                        thickness: 1.0,
                        color: Color(0xffE72A28).withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ListTile(
                          title: Text("Privacy Policy",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                          dense: true,
                          leading: Icon(FontAwesomeIcons.file,size: 18.0,),
                          trailing:  Icon(FontAwesomeIcons.chevronRight,color:Color(0xffEF3651),size: 16.0, ),
                        ),
                      ),
                      Divider(
                        indent: 4.0,
                        endIndent: 4.0,
                        thickness: 1.0,
                        color: Color(0xffE72A28).withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ListTile(
                          title: Text("About",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily),),
                          dense: true,
                          leading: Icon(FontAwesomeIcons.info,size: 18.0,),
                          trailing:Icon(FontAwesomeIcons.chevronRight,color:Color(0xffEF3651),size: 16.0, ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff2A2C36),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff2A2C36),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.logout,color:Color(0xffEF3651),),
                      const SizedBox(width: 5.0,),
                      GestureDetector(
                          child: Text("Logout",style: TextStyle(fontSize:16.0 ,fontFamily: kfontfamily,color: Color(0xffEF3651)),),
                        onTap: () async{

                            if(Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true){
                              _progressDialog.show();
                              await Provider.of<authenticationanduserprovider>(context,listen: false).signout();
                              _progressDialog.dismiss();
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("No user logged in",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              );
                            }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0,),
              ],
      ),
          ),
        ),
        ),
    );
  }
}


