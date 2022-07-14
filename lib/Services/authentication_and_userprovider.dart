import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

// ignore: camel_case_types
class authenticationanduserprovider with ChangeNotifier{

  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;

  final googlesignin=GoogleSignIn();
  final facebooklogin=FacebookLogin();

  static String message;

  static bool emailexists;

  static bool emailverif;

  Future<void> signinwithemailandpass({String email,String pass}) async{
    emailverif=false;
    try{
      message=null;
     final UserCredential userCredential= await firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
     if(userCredential.user!=null){
       if(userCredential.user.emailVerified){
         emailverif=true;
         notifyListeners();
       }
       else{
         emailverif=false;
         message="Verify your email please";
         await firebaseAuth.signOut();
         notifyListeners();
       }
     }
    }on FirebaseAuthException catch(e){
      message=e.message;
    }
  }

  Future<void> signinwithgoogle() async{
      message=null;
      final googleaccount=await googlesignin.signIn();
      if(googleaccount!=null){
        final googleauth=await googleaccount.authentication;
        if(googleauth.accessToken!=null && googleauth.idToken!=null){
          final UserCredential userCredential=await firebaseAuth.signInWithCredential(

            GoogleAuthProvider.credential(
              idToken: googleauth.idToken,
              accessToken: googleauth.accessToken),

          );
          var doc=await _firestore.collection('users').doc(userCredential.user.uid).get();
          if(doc.exists==false){
            await _firestore.collection('users').doc(userCredential.user.uid).set({
              'billingaddress':"This is a dummy address",
              'name':userCredential.user.displayName,
              'profilepic':userCredential.user.photoURL,
              'shippingaddress':"This is a dummy address",
              'dateofbirth':Timestamp.fromDate(DateTime.now())
            });
          }
          notifyListeners();
        }else{
          message="Missing Google Auth Token";
        }
      }else{
        message="Sign in aborted by user";
      }
  }

  Future<void> signinwithfacebook() async{
    message=null;
    final result = await facebooklogin.logInWithReadPermissions(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      final UserCredential userCredential=await firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(
          result.accessToken.token,
        ),
      );
      var doc=await _firestore.collection('users').doc(userCredential.user.uid).get();
      if(doc.exists==false){
        await _firestore.collection('users').doc(userCredential.user.uid).set({
          'billingaddress':"This is a dummy address",
          'name':userCredential.user.displayName,
          'profilepic':userCredential.user.photoURL,
          'shippingaddress':"This is a dummy address",
          'dateofbirth':Timestamp.fromDate(DateTime.now())
        });
      }else{
        //user profile loading options here
      }
      notifyListeners();
    } else {
        message='Sign in aborted by user';
    }
    }

    Future<void> checkemail({String email}) async{
      emailexists=false;
      List<String> methods=await firebaseAuth.fetchSignInMethodsForEmail(email);
      if(methods.length==0){
        emailexists=false;
      }else if(methods.length>0){
        emailexists=true;
      }
    }

    Future<void> resetemail({String email})async{
      message=null;
     await firebaseAuth.sendPasswordResetEmail(email: email);
    }

    Future<void> updatepass({String pass,String currentpass})async{
      message=null;
        final User us=firebaseAuth.currentUser;
        try{
        AuthCredential credential =  EmailAuthProvider.credential(email: us.email, password: currentpass);
        UserCredential userCredential=await us.reauthenticateWithCredential(credential);
        if(userCredential.user!=null){
          await us.updatePassword(pass);
          message="Password updated";
        }
        }catch(e){
          message=e.toString();
        }
    }

    Future<void> createuserwithemailandpass({String email,String pass,String name}) async{
      message=null;
      try{
        UserCredential result=await firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
        if(result.user!=null){
          result.user.sendEmailVerification();
          await _firestore.collection('users').doc(result.user.uid).set({
            'billingaddress':"asdasdsa",
            'name':name,
            'profilepic':"",
            'shippingaddress':"asdsadsa",
            'dateofbirth':Timestamp.fromDate(DateTime.now())
          });
          await firebaseAuth.signOut();
          notifyListeners();
          message="Click the link sent to email address and then login";
        }
        else{
          message="User creation failed";
        }
      }catch(e){
        message=e.toString();
      }
    }


  Future<void> signout() async{
    message=null;
    final User=firebaseAuth.currentUser;
    if(User!=null){
      try{
        await facebooklogin.logOut();
        await googlesignin.signOut();
        await firebaseAuth.signOut();
        notifyListeners();
      }on FirebaseAuthException catch(e){
        message=e.message;
      }
    }
  }

  bool isloggedin(){
    if(firebaseAuth.currentUser!=null){
      return true;
    }else{
      return false;
    }
  }

  String providertype(){
    final User=firebaseAuth.currentUser;
    if(User!=null){
      return User.providerData.single.providerId.toString();
    }else{
      return "";
    }
  }
  usser _userdatafromsnapshot(DocumentSnapshot snapshot){
    Timestamp ts=snapshot['dateofbirth'];
    DateTime dt=ts.toDate();
    return usser(email:firebaseAuth.currentUser.email, name:snapshot['name'], profilepic:snapshot['profilepic'], shippingaddress:snapshot['shippingaddress'],
        billingaddress:snapshot['billingaddress'],dateofbirth:dt);
  }
  Stream<usser> get userdata{// we have made a stream here to listen to changes in the user document
    return _firestore.collection('users').doc(firebaseAuth.currentUser.uid).snapshots().map(_userdatafromsnapshot); //snapshots will return a document snapshot everytime the data is changed
  }

  Future<bool> updateusername(String name) async{
    message=null;
    try{
      await _firestore.collection('users').doc(firebaseAuth.currentUser.uid).update({
      'name':name
    });
    return true;
    }catch(e){
      message=e.toString();
    }
  }

  Future<void> updateshipaddress(String address) async{
    message=null;
    try{
      await _firestore.collection('users').doc(firebaseAuth.currentUser.uid).update({
        'shippingaddress':address
      });
      message="Shipping address updated";
    }catch(e){
      message=e.toString();
    }

  }

  Future<void> updatebilladdress(String address) async{
    message=null;
    try{
      await _firestore.collection('users').doc(firebaseAuth.currentUser.uid).update({
        'billingaddress':address
      });
      message="Billing address updated";
    }catch(e){
      message=e.toString();
    }

  }

  Future<bool> updatedob(DateTime dt) async{
    message=null;
    try{
      Timestamp ts=Timestamp.fromDate(dt);
      await _firestore.collection('users').doc(firebaseAuth.currentUser.uid).update({
        'dateofbirth':ts
      });
      return true;
    }catch(e){
      message=e.toString();
    }
  }
  Future<bool> updateprofilepic() async{
    message=null;
    try{
      final PickedFile pickedfile=await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      final File croppedfile=await ImageCropper.cropImage(
          sourcePath: pickedfile.path,
          aspectRatioPresets:[
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );
      var ref=_firebaseStorage.ref().child("user/profile/${firebaseAuth.currentUser.uid}");
      var upload=ref.putFile(croppedfile);
      var downloadurl=await(await upload).ref.getDownloadURL();
      await _firestore.collection('users').doc(firebaseAuth.currentUser.uid).update({
        'profilepic':downloadurl
      });
      message="Profile pic updated";
    }catch(e){
      message="Operation Unsuccessful";
    }
  }

  Future<String> profilepicpath() async{
    String picpath=await _firebaseStorage.ref().child("user/profile/${firebaseAuth.currentUser.uid}").getDownloadURL();
    return picpath;
  }
}

class usser{
  final String email;
  final String name;
  final String profilepic;
  final String shippingaddress;
  final String billingaddress;
  final DateTime dateofbirth;
  usser({this.email, this.name, this.profilepic, this.shippingaddress, this.billingaddress, this.dateofbirth});
}

