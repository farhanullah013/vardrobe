import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class post_review{
  static postreview({int rating,String review,Timestamp ts,bool sale,String docid}) async {
    DocumentSnapshot ds=await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get();
    Map<String,dynamic> userdata=ds.data();
    if(sale==true){
          QuerySnapshot result= await FirebaseFirestore.instance.collection('sale_product').doc(docid).collection('reviews').where('name',isEqualTo:userdata['name']).get();
          if(result.size==0){
            try{
              DocumentReference dr=await FirebaseFirestore.instance.collection('sale_product').doc(docid).collection('reviews').add({
                'date':ts,
                'imageurl':userdata['profilepic'],
                'name':userdata['name'],
                'rating':rating,
                'review':review
              });
              if(dr.id!=null){
                await FirebaseFirestore.instance.collection('sale_product').doc(docid).update({
                  'numreviews':FieldValue.increment(1)
                });
              }else{

              }
            }catch(e){

            }
          }else{

          }

    }else{

      QuerySnapshot result= await FirebaseFirestore.instance.collection('products').doc(docid).collection('reviews').where('name',isEqualTo:userdata['name']).get();
      if(result.size==0){
        try{
        DocumentReference dr=await FirebaseFirestore.instance.collection('products').doc(docid).collection('reviews').add({
          'date':ts,
          'imageurl':userdata['profilepic'],
          'name':userdata['name'],
          'rating':rating,
          'review':review
        });
        if(dr.id!=null){
          await FirebaseFirestore.instance.collection('products').doc(docid).update({
            'numreviews':FieldValue.increment(1)
          });
        }else{
        }
        }catch(e){
        }
      }else{
      }
    }
  }
}