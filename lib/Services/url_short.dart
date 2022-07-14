import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class short{

static Future<String> shortner(String longurl,String prodid) async{

  var url = Uri.parse("");
  var headers={'Authorization': '','Content-Type': 'application/json'};
  var body=json.encode({
    "long_url":longurl,
    "domain": "bit.ly",
  });

  final result=await http.post(url,headers:headers,body: body);
  String producturl;
    Map<String,dynamic> results=json.decode(result.body);
  producturl=results["link"];

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
  var ref=FirebaseStorage.instance.ref().child("virtual/${FirebaseAuth.instance.currentUser.uid}");
  var upload=ref.putFile(croppedfile);
  var downloadurl=await(await upload).ref.getDownloadURL();


  String userurl;

  var url1 = Uri.parse("");
  var body1=json.encode({
    "long_url":downloadurl,
    "domain": "bit.ly",
  });

  final result1=await http.post(url1,body: body1,headers: headers);

    Map<String,dynamic> results1=json.decode(result1.body);
    userurl=results1["link"];

    print( producturl);
    print(userurl);
    var url2 = Uri.parse("");

  http.Response response = await http.get(url2);
  Map<String,dynamic> results2=json.decode(response.body);
  return(results2["0"]);

}

}