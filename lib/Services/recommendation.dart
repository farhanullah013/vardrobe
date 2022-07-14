import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class recommend {
  
  static Future<Map<String, dynamic>> recommendfromcart() async {
    QuerySnapshot qs=await FirebaseFirestore.instance.collection("cart").get();
    List<QueryDocumentSnapshot> doc=qs.docs;
    String prodid;
    bool saleprod;
    for(int i=0;i<=doc.length;i++){
      if(doc[i].id!=""){
        prodid=qs.docs[i]['productid'];
        saleprod=qs.docs[i]['saleprod'];
        break;
      }
    }
    DocumentSnapshot ds;
    if(saleprod==true){
     ds=await FirebaseFirestore.instance.collection('sale_product').doc(prodid).get();
    }else{
      ds=await FirebaseFirestore.instance.collection('products').doc(prodid).get();
    }
    Map<String,dynamic> result=ds.data();
    String cat=result['category'][0];
    cat=cat.toLowerCase();
    print(cat);
    var url = Uri.parse(
        "");
    http.Response response = await http.get(url);
    Map<String,dynamic> results=json.decode(response.body);
    return results;
  }
}