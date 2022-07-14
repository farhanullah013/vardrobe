import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:vardrobe/Screens/forgot_password_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vardrobe/Screens/signup_screen.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Widgets/round_button.dart';
import 'package:vardrobe/Widgets/social_container.dart';
import 'package:email_validator/email_validator.dart';

class login_screen extends StatefulWidget {
  @override
  _login_screenState createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {

  TextEditingController _emailtextediting=TextEditingController();
  TextEditingController _passwordtextediting=TextEditingController();

  final _form=GlobalKey<FormState>();


  ArsProgressDialog _progressDialog;

  bool _saveform(){
    final isvalid=_form.currentState.validate();
    if(!isvalid){
      Toast.show("Please enter valid values", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
      return false;
    }
    return true;
  }

  bool _obstext=true;

  @override
  void dispose() {
    _emailtextediting.dispose();
    _passwordtextediting.dispose();
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
                  child: Text('Login',style: TextStyle(fontSize: 40.0,fontFamily: 'Nunito-Bold'),),
                ),
                const  SizedBox(height: 40.0,),
                Form(
                  key: _form,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextFormField(
                            maxLength: 30,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            validator: (text)=>EmailValidator.validate(text) ?null: "",
                            controller: _emailtextediting,
                            keyboardType: TextInputType.emailAddress,
                            decoration: formfield.copyWith(
                                hintText: 'Email',
                              counter: Offstage(),
                            ),
                          ),
                        ),
                        const  SizedBox(height: 10.0,),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextFormField(
                            maxLength: 20,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            validator: (text)=>text.isNotEmpty?null:"",
                            controller: _passwordtextediting,
                            obscureText: _obstext,
                            decoration: formfield.copyWith(
                              counter: Offstage(),
                              hintText: 'Password',
                              suffixIcon: _obstext==false?IconButton(
                                icon: Icon(FontAwesomeIcons.eye),
                                color: Colors.blue,
                                onPressed: (){
                                  setState(() {
                                    _obstext=!_obstext;
                                  });
                                },
                              ):IconButton(
                                icon: Icon(FontAwesomeIcons.eyeSlash),
                                color: Colors.green,
                                onPressed: (){
                                  setState(() {
                                    _obstext=!_obstext;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
                const  SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: TextButton(
                        onPressed: (){
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          Navigator.pop(context);
                          Navigator.push(context, PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                              },
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                return forgot_password_screen();
                              }
                          ));
                        },
                        child: Text('Forgot your password?',style: TextStyle(color: Colors.white,fontFamily:kfontfamily,fontSize: 17.0),),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                            },
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                              return forgot_password_screen();
                            }
                        ));
                      },
                      icon: Icon(FontAwesomeIcons.longArrowAltRight,color: Colors.pink,),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: TextButton(
                        onPressed: (){
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          Navigator.pop(context);
                          Navigator.push(context, PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                              },
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                return signin_screen();
                              }
                          ));
                        },
                        child: Text('Dont have an account?',style: TextStyle(color: Colors.white,fontFamily:kfontfamily,fontSize: 17.0),),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.push(context, PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                              return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                            },
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                              return signin_screen();
                            }
                        ));
                      },
                      icon: Icon(FontAwesomeIcons.longArrowAltRight,color: Colors.pink,),
                    ),
                  ],
                ),
                const  SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: roundbutton(text:'Login',callback: () async {
                    if(!_emailtextediting.text.contains("gmail")){
                    bool proceed=_saveform();
                    if(proceed==true){
                        _progressDialog.show();
                        await Provider.of<authenticationanduserprovider>(context,listen: false).signinwithemailandpass(email: _emailtextediting.text,pass: _passwordtextediting.text);
                        if(Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true){
                          _progressDialog.dismiss();
                          authenticationanduserprovider.emailverif==false?Toast.show(authenticationanduserprovider.message, context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER):null;
                          Future.delayed(const Duration(seconds: 3));
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
                    }
                  }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please login with your gmail account",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                    }
                  },),
                ),
                const SizedBox(height: 130.0,),
                Center(
                  child: Container(
                    child: Text('Or Login with a social account',style: TextStyle(fontFamily:kfontfamily,fontSize: 19.0),),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () async{
                          _progressDialog.show();
                          await Provider.of<authenticationanduserprovider>(context,listen: false).signinwithgoogle();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}



