import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Widgets/round_button.dart';
import 'package:vardrobe/Widgets/social_container.dart';

import 'login_screen.dart';


class signin_screen extends StatefulWidget {
  @override
  _signin_screenState createState() => _signin_screenState();
}

class _signin_screenState extends State<signin_screen> {

  TextEditingController _emailtextediting=TextEditingController();
  TextEditingController _passwordtextediting=TextEditingController();
  TextEditingController _cppasswordtextediting=TextEditingController();
  TextEditingController _nameediting=TextEditingController();

  final _form=GlobalKey<FormState>();

  ArsProgressDialog _progressDialog;

  bool _saveform(){
    final isvalid=_form.currentState.validate();
    if(!isvalid){
      return false;
    }
    return true;
  }

  bool _obstextp=true;
  bool _obstextcp=true;
  
  @override
  void dispose() {
    _emailtextediting.dispose();
    _passwordtextediting.dispose();
    _cppasswordtextediting.dispose();
    _nameediting.dispose();
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
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        backgroundColor:const Color.fromRGBO(30, 31, 40, 1.0),
        appBar: AppBar(
          backgroundColor:const Color.fromRGBO(30, 31, 40, 1.0) ,
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,),
            onPressed: (){
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:<Widget> [
                const SizedBox(height: 20.0,),
                Container(
                  child: Text('Sign up',style: TextStyle(fontSize: 40.0,fontFamily: 'Nunito-Bold'),),
                ),
                const SizedBox(height: 40.0,),
                Form(
                  key: _form,
                  child: Column(
                    children:<Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: _nameediting,
                          validator: (text){
                            if(text.isEmpty){
                              return 'Name cant be empty';
                            }else if(!text.contains(new RegExp(r'^[A-Za-z ]+$'))){
                              return "Only alphabets allowed";
                            }
                            return null;
                          },
                          maxLength: 20,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          keyboardType: TextInputType.name,
                          decoration: formfield.copyWith(
                            hintText: 'Name',
                            counter: Offstage(),
                        ),
                      ),
                    ),
                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: _emailtextediting,
                          validator: (text)=>EmailValidator.validate(text) ?null: "Email cannot be empty",
                          maxLength: 30,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          keyboardType: TextInputType.emailAddress,
                          decoration: formfield.copyWith(
                              hintText: 'Email',
                              counter: Offstage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: _passwordtextediting,
                          maxLength: 20,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          obscureText: _obstextp,
                          validator: (text){
                            if(text.isEmpty){
                              return 'Password cant be empty';
                            }else if(text.length<=6){
                              return 'Password has to be more than 6 characters long';
                            }
                            return null;
                          },
                          decoration: formfield.copyWith(
                            hintText: 'Password',
                            suffixIcon: _obstextp==false?IconButton(
                              icon: Icon(FontAwesomeIcons.eye),
                              color: Colors.blue,
                              onPressed: (){
                                setState(() {
                                  _obstextp=!_obstextp;
                                });
                              },
                            ):IconButton(
                              icon: Icon(FontAwesomeIcons.eyeSlash),
                              color: Colors.green,
                              onPressed: (){
                                setState(() {
                                  _obstextp=!_obstextp;
                                });
                              },
                            ),
                            counter: Offstage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFormField(
                          controller: _cppasswordtextediting,
                          maxLength: 20,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          obscureText: _obstextcp,
                          validator: (text)=>text.isNotEmpty?null:"",
                          decoration: formfield.copyWith(
                            hintText: 'Confirm Password',
                            suffixIcon: _obstextcp==false?IconButton(
                              icon: Icon(FontAwesomeIcons.eye),
                              color: Colors.blue,
                              onPressed: (){
                                setState(() {
                                  _obstextcp=!_obstextcp;
                                });
                              },
                            ):IconButton(
                              icon: Icon(FontAwesomeIcons.eyeSlash),
                              color: Colors.green,
                              onPressed: (){
                                setState(() {
                                  _obstextcp=!_obstextcp;
                                });
                              },
                            ),
                            counter: Offstage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                const SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(

                      child: TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(context, PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                              },
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                return login_screen();
                              }
                          ));
                        },

                        child: Text('Already have an account?',style: TextStyle(color: Colors.white,fontFamily: kfontfamily,fontSize: 17.0),),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                            return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                          },
                          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                            return login_screen();
                          }
                      ));
                        },
                      icon: Icon(FontAwesomeIcons.longArrowAltRight,color: Colors.pink,),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: roundbutton(text:'Sign up',callback: () async{
                    if(!_emailtextediting.text.contains("gmail")){
                      bool proceed=_saveform();
                    if(_passwordtextediting.text!=_cppasswordtextediting.text){
                    Toast.show("Passwords do not match", context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                  }
                    else if(_passwordtextediting.text==_cppasswordtextediting.text && proceed==true){
                      _progressDialog.show();
                      await Provider.of<authenticationanduserprovider>(context,listen: false).checkemail(email: _emailtextediting.text);
                      if(authenticationanduserprovider.emailexists==false){
                        await Provider.of<authenticationanduserprovider>(context,listen: false).createuserwithemailandpass(email: _emailtextediting.text,pass: _passwordtextediting.text,name: _nameediting.text);
                        _progressDialog.dismiss();
                        Toast.show(authenticationanduserprovider.message, context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                        Future.delayed(Duration(seconds: 3));
                        Navigator.pop(context);
                      }else{
                        _progressDialog.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User with this mail already exists",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                            backgroundColor: Colors.blueAccent,
                          ),
                        );
                      }
                    }
                  }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please login using your gmail account",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                    }
                  }
                  ),
                ),
                const SizedBox(height: 80.0,),
                Center(
                  child: Container(
                    child: Text('Get quick access through',style: TextStyle(fontFamily: kfontfamily,fontSize: 19.0),),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: ()async{
                          _progressDialog.show();
                          await Provider.of<authenticationanduserprovider>(context,listen: false).signinwithgoogle();
                          if(Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true){
                            _progressDialog.dismiss();
                            Future.delayed(const Duration(seconds: 1));
                          }
                          else{
                            _progressDialog.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(authenticationanduserprovider.message,style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                                backgroundColor: Colors.blueAccent,
                              ),
                            );
                          }
                        },
                        child: social_container(path:'Assets/images/google.png')
                    ),
                    const SizedBox(width: 15.0,),
                    GestureDetector(
                      onTap: () async{
                        _progressDialog.show();
                        await Provider.of<authenticationanduserprovider>(context,listen: false).signinwithfacebook();
                        if(Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true){
                          _progressDialog.dismiss();
                          Future.delayed(const Duration(seconds: 1));
                          Navigator.pop(context);
                        }
                        else{
                          _progressDialog.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(authenticationanduserprovider.message,style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                              backgroundColor: Colors.blueAccent,
                            ),
                          );
                        }
                      },
                      child: social_container(path:'Assets/images/facebook.png'),
                    ),
                  ],
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