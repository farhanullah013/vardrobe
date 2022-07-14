import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Widgets/round_button.dart';

class forgot_password_screen extends StatefulWidget {
  @override
  _forgot_password_screenState createState() => _forgot_password_screenState();
}

class _forgot_password_screenState extends State<forgot_password_screen> {

  final _form=GlobalKey<FormState>();

  bool _valid=true;
  TextEditingController _emailtextediting=TextEditingController();

  bool _saveform(){
    final isvalid=_form.currentState.validate();
    if(!isvalid){
      _valid=false;
      Toast.show("Please enter valid email", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
      return false;
    }
    _valid=true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text('Forgot password',style: TextStyle(fontSize: 40.0,fontFamily: 'Nunito-Bold'),),
                ),
                const SizedBox(height: 100.0,),
                Container(
                  child: Text('Please, enter your email address. You will receive a link to create a new password via email.',style: TextStyle(fontSize: 14.0,fontFamily: kfontfamily),),
                ),
                const SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Form(
                    key: _form,
                    child: TextFormField(
                      maxLength: 30,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: _emailtextediting,
                      validator: (text)=>EmailValidator.validate(text) ?null: "",
                      keyboardType: TextInputType.emailAddress,
                      decoration: formfield.copyWith(
                          hintText: 'Email',
                          suffixIcon:_valid==false?Icon(FontAwesomeIcons.times,color: Color(0xffFF2424),):null,
                          counter: Offstage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80.0,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: roundbutton(text:'Send',callback: () async{
                    setState(() {
                      _valid=!_valid;
                    });
                    bool proceed=_saveform();
                    if(proceed==true){
                      if(!_emailtextediting.text.contains("gmail")){
                        await Provider.of<authenticationanduserprovider>(context,listen: false).checkemail(email: _emailtextediting.text);
                        if(authenticationanduserprovider.emailexists==true){
                          await Provider.of<authenticationanduserprovider>(context,listen: false).resetemail(email: _emailtextediting.text);
                          Navigator.pop(context);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No such user",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                              backgroundColor: Colors.blueAccent,
                            ),
                          );
                        }
                    }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please login with your gmail account",style: TextStyle(fontFamily: kfontfamily,fontSize: 14.0),),
                            backgroundColor: Colors.blueAccent,
                          ),
                        );
                      }
                    }
                  },),
                ),
                const SizedBox(height: 130.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
