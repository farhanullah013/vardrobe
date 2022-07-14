import 'package:cloud_firestore/cloud_firestore.dart';

class best_seller{

  Future<List<QueryDocumentSnapshot>> get products async {
    DocumentSnapshot a=await FirebaseFirestore.instance.collection('best_sellers').doc('').collection('products').doc('').get();
    List<String> best = new List<String>.from(a.data().values.first);
    QuerySnapshot products=await FirebaseFirestore.instance.collection('products').get();
    List<QueryDocumentSnapshot> plist =products.docs;
    List<QueryDocumentSnapshot> toremove=<QueryDocumentSnapshot>[];
    plist.forEach((element) {
      if(best.contains(" "+element.id)){
      }else{
        toremove.add(element);
      }
    });
    plist.removeWhere((value)=>toremove.contains(value));
    return plist;
  }

  Future<List<QueryDocumentSnapshot>> get sale_products async {
    DocumentSnapshot a=await FirebaseFirestore.instance.collection('best_sellers').doc('').collection('sale_product').doc('').get();
    List<String> best = new List<String>.from(a.data().values.first);
    QuerySnapshot products=await FirebaseFirestore.instance.collection('sale_product').get();
    List<QueryDocumentSnapshot> plist =products.docs;
    List<QueryDocumentSnapshot> toremove=<QueryDocumentSnapshot>[];
    plist.forEach((element) {
      if(best.contains(element.id)){
      }else{
        toremove.add(element);
      }
    });
    plist.removeWhere((value)=>toremove.contains(value));
    return plist;
  }
}