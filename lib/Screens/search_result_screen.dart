import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:vardrobe/Screens/cart_screen.dart';
import 'package:vardrobe/Screens/favourites_screen.dart';
import 'package:vardrobe/Screens/scraper_screen.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:vardrobe/Widgets/filters_and_sort.dart';
import 'package:vardrobe/Widgets/new_product.dart';
import 'package:vardrobe/Widgets/size_and_colorfilter.dart';
import 'package:vardrobe/Widgets/sort_filters_and_catsearch.dart';
import 'package:vardrobe/Services/algolia_search.dart';
import 'login_screen.dart';

class search_result_screen extends StatefulWidget {
  final bool iscat;
  final String keyword;

  const search_result_screen({this.iscat, this.keyword});
  @override
  _search_result_screenState createState() => _search_result_screenState();
}

class _search_result_screenState extends State<search_result_screen> {

  String _filtervalue=sortfilters.sortfilter[0];

  RangeValues _currentvalues= const RangeValues(40, 80); //price values
  int _defaultcolorchipindex=0; //default color
  int _defaultsizechipindex=0;//default size
  double _currentvalue=1; //default rating

  String _sortfilterselected;//checking if some sort is selected
  bool _filtersapplied=false; //if some filters are applied

  final Algolia _algoliaApp = algolia_search.algolia;

  Future<List<QueryDocumentSnapshot>> _operation(String input) async {
    List<dynamic> matchedprodid=[];
    AlgoliaQuery query = _algoliaApp.instance.index("products").query(input).setQueryType(QueryType.prefixAll).setHitsPerPage(10);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    for(int i=0;i<results.length;i++){
      matchedprodid.add(results[0].data['objectID']);
    }
    if(_filtersapplied==false){
    if(_sortfilterselected==null){
      QuerySnapshot prodsfromfirestore=await FirebaseFirestore.instance.collection('products').get();
      List<QueryDocumentSnapshot> plist =prodsfromfirestore.docs;
      List<QueryDocumentSnapshot> toremove=<QueryDocumentSnapshot>[];
      plist.forEach((element) {
        if(matchedprodid.contains(element.id)){
        }else{
          toremove.add(element);
        }
      });
      plist.removeWhere((value)=>toremove.contains(value));
      return plist;
    }else{
      QuerySnapshot prodsfromfirestore;
      switch (_sortfilterselected) {
        case "Date: Old to new":
           prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('date',descending: true).get();
          break;
        case "Date: New to old":
           prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('date',descending: false).get();
          break;
        case "Price: Low to high":
          prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('price',descending: true).get();
          break;
        case "Price: High to low":
          prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('price',descending: false).get();
          break;
        case "Reviews: Low to high rating":
          prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('numreviews',descending: true).get();
          break;
        case "Price: High to low rating":
          prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('numreviews',descending: false).get();
          break;
      }
      List<QueryDocumentSnapshot> plist =prodsfromfirestore.docs;
      List<QueryDocumentSnapshot> toremove=<QueryDocumentSnapshot>[];
      plist.forEach((element) {
        if(matchedprodid.contains(element.id)){
        }else{
          toremove.add(element);
        }
      });
      plist.removeWhere((value)=>toremove.contains(value));
      return plist;
    }
    }else{
      if(_sortfilterselected==null){
        QuerySnapshot prodsfromfirestore=await FirebaseFirestore.instance.collection('products').get();
        List<QueryDocumentSnapshot> plist =prodsfromfirestore.docs;
        List<QueryDocumentSnapshot> toremove=<QueryDocumentSnapshot>[];
        plist.forEach((element) {
          if(matchedprodid.contains(element.id)){
          }else{
            toremove.add(element);
          }
        });
        plist.removeWhere((value)=>toremove.contains(value));
        return plist;
      }else{
        QuerySnapshot prodsfromfirestore;
        switch (_sortfilterselected) {
          case "Date: Old to new":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('date',descending: true).get();
            break;
          case "Date: New to old":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('date',descending: false).get();
            break;
          case "Price: Low to high":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('price',descending: true).get();
            break;
          case "Price: High to low":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('price',descending: false).get();
            break;
          case "Reviews: Low to high rating":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('numreviews',descending: true).get();
            break;
          case "Price: High to low rating":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').orderBy('numreviews',descending: false).get();
            break;
        }
        List<QueryDocumentSnapshot> plist =prodsfromfirestore.docs;
        List<QueryDocumentSnapshot> toremove=<QueryDocumentSnapshot>[];
        plist.forEach((element) {
          if(matchedprodid.contains(element.id)){
          }else{
            toremove.add(element);
          }
        });
        for(int i=0;i<plist.length;i++){ //price filter
          if((plist[i]['price']>=_currentvalues.start.round()) && (plist[i]['price']<=_currentvalues.end.round())){
          }else{
            toremove.add(plist[i]);
          }
        }
        for(int i=0;i<plist.length;i++){ //rating filter
          if(plist[i]['rating']==_currentvalue.toInt()){
          }else{
            toremove.add(plist[i]);
          }
        }
        for(int i=0;i<plist.length;i++){
          List<dynamic> colors=plist[i]['colors'];
          if(colors.contains(colorfilter().colorchoices[_defaultcolorchipindex])){
          }else{
            toremove.add(plist[i]);
          }
        }
        for(int i=0;i<plist.length;i++){
          List<dynamic> sizes=plist[i]['sizes'];
          if(sizes.contains(sizefilter().choices[_defaultsizechipindex])){
          }else{
            toremove.add(plist[i]);
          }
        }
        plist.removeWhere((value)=>toremove.contains(value));
        return plist;
      }
    }
  }

  Future<List<QueryDocumentSnapshot>> _operation1(String input) async {
    if(_filtersapplied==false){
      if(_sortfilterselected==null){
        QuerySnapshot prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).get();
        List<QueryDocumentSnapshot> plist =prodsfromfirestore.docs;
        return plist;
      }else{
        QuerySnapshot prodsfromfirestore;
        switch (_sortfilterselected) {
          case "Date: Old to new":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('date',descending: false).get();
            break;
          case "Date: New to old":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('date',descending: true).get();
            break;
          case "Price: Low to high":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('price',descending: false).get();
            break;
          case "Price: High to low":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('price',descending: true).get();
            break;
          case "Reviews: Low to high rating":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('numreviews',descending: false).get();
            break;
          case "Reviews: High to low rating":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('numreviews',descending: true).get();
            break;
        }
        List<QueryDocumentSnapshot> plist =prodsfromfirestore.docs;
        return plist;
      }
    }else{
      if(_sortfilterselected==null){
        QuerySnapshot prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).
        where('price',isGreaterThanOrEqualTo: _currentvalues.start.round()).where('price',isLessThanOrEqualTo: _currentvalues.end.round()).where('rating',isEqualTo: _currentvalue.toInt()).get();
        List<QueryDocumentSnapshot> plist =prodsfromfirestore.docs;
        List<QueryDocumentSnapshot> toremove=<QueryDocumentSnapshot>[];
        for(int i=0;i<plist.length;i++){
          List<dynamic> colors=plist[i]['colors'];
          if(colors.contains(colorfilter().colorchoices[_defaultcolorchipindex])){
          }else{
            toremove.add(plist[i]);
          }
        }
        for(int i=0;i<plist.length;i++){
          List<dynamic> sizes=plist[i]['sizes'];
          if(sizes.contains(sizefilter().choices[_defaultsizechipindex])){
          }else{
            toremove.add(plist[i]);
          }
        }
        plist.removeWhere((value)=>toremove.contains(value));
        return plist;
      }else{
        QuerySnapshot prodsfromfirestore;
        switch (_sortfilterselected) {
          case "Date: Old to new":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('date',descending: false).get();
            break;
          case "Date: New to old":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('date',descending: true).get();
            break;
          case "Price: Low to high":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('price',descending: false).get();
            break;
          case "Price: High to low":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('price',descending: true).get();
            break;
          case "Reviews: Low to high rating":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('numreviews',descending: false).get();
            break;
          case "Reviews: High to low rating":
            prodsfromfirestore=await FirebaseFirestore.instance.collection('products').where('category',arrayContains:input).orderBy('numreviews',descending: true).get();
            break;
        }
        List<QueryDocumentSnapshot> plist =prodsfromfirestore.docs;
        List<QueryDocumentSnapshot> toremove=<QueryDocumentSnapshot>[];

        for(int i=0;i<plist.length;i++){ //price filter
          if((plist[i]['price']>=_currentvalues.start.round()) && (plist[i]['price']<=_currentvalues.end.round())){
          }else{
            toremove.add(plist[i]);
          }
        }
        for(int i=0;i<plist.length;i++){ //rating filter
          if(plist[i]['rating']==_currentvalue.toInt()){
          }else{
            toremove.add(plist[i]);
          }
        }
        for(int i=0;i<plist.length;i++){
          List<dynamic> colors=plist[i]['colors'];
          if(colors.contains(colorfilter().colorchoices[_defaultcolorchipindex])){
          }else{
            toremove.add(plist[i]);
          }
        }
        for(int i=0;i<plist.length;i++){
          List<dynamic> sizes=plist[i]['sizes'];
          if(sizes.contains(sizefilter().choices[_defaultsizechipindex])){
          }else{
            toremove.add(plist[i]);
          }
        }
        plist.removeWhere((value)=>toremove.contains(value));
        return plist;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:Container(
        height:70.0 ,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 10.0,
            child: Icon(FontAwesomeIcons.spider,color: Colors.black,size: 28.0,),
            backgroundColor: Color(0xffEF3651),
            onPressed: (){
              Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true?Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 600),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                    return scraper_screen(keyword: widget.keyword,);
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
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,size: 22.0,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 1.0,
        backgroundColor:const  Color.fromRGBO(30, 31, 40, 1.0),
        title: Text(widget.keyword,style: TextStyle(fontFamily: kfontfamily,fontSize: 30.0),),
        actions: <Widget>[
          IconButton(
            icon:Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 28.0,
            ),
            onPressed: (){
              Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true?Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                    return cart_Screen();
                  }
              )):Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                    return login_screen();
                  }
              ));
            },
          ),
          IconButton(
            icon:Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 28.0,
            ),
            onPressed: (){
              Navigator.pop(context);
              Provider.of<authenticationanduserprovider>(context,listen: false).isloggedin()==true?Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                    return favourites_screen();
                  }
              )):Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                    return login_screen();
                  }
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0),
          child: Column(
            children: <Widget>[
              widget.iscat==true?StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: Stream.fromFuture(_operation1(widget.keyword)),
                builder: (context,AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot){
                  if(snapshot.hasError){
                    print(snapshot.error);
                    return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                  }
                  else if(snapshot.connectionState==ConnectionState.waiting){
                    return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                    Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                  }else if(snapshot.data.length==0){
                    return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.5,child:
                    Center(child: Text('No products match your search',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                  }else{
                    final List<QueryDocumentSnapshot> list=snapshot.data;
                    return Column(
                      children:<Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: filtersandsort(filtername: "Filter",icontype: FontAwesomeIcons.filter,),
                              onTap: (){
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder:(context)=>Container(
                                    decoration: BoxDecoration(
                                        color:const  Color.fromRGBO(30, 31, 40, 1.0),
                                        borderRadius: BorderRadius.only(topRight:Radius.circular(35.0) ,topLeft: Radius.circular(35.0),)
                                    ),
                                    child: StatefulBuilder(
                                      builder: (BuildContext con,StateSetter state){
                                        return Padding(
                                          padding: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:<Widget> [
                                              Align(alignment: Alignment.topCenter,child: Text("Filters",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),)),
                                              const SizedBox(height: 20.0,),
                                              Text("Price range",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                              const SizedBox(height: 20.0,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("\$"+"${_currentvalues.start.round()}",style: TextStyle(fontFamily: kfontfamily,fontSize: 16.0),),
                                                  Text("\$"+"${_currentvalues.end.round()}",style: TextStyle(fontFamily: kfontfamily,fontSize: 16.0),),
                                                ],
                                              ),
                                              RangeSlider(
                                                  divisions: 1000,
                                                  activeColor: Color(0xffEF3651),
                                                  inactiveColor: Colors.grey,
                                                  values:_currentvalues,
                                                  min: 1,
                                                  max: 5000,
                                                  labels: RangeLabels(
                                                    _currentvalues.start.round().toString(),
                                                    _currentvalues.end.round().toString(),
                                                  ),
                                                  onChanged:(RangeValues value){
                                                    state(()=>_currentvalues=value);
                                                  }
                                              ),
                                              const SizedBox(height: 30.0,),
                                              Text("Colors",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                              const SizedBox(height: 10.0,),
                                              SizedBox(
                                                height: 50.0,
                                                child: ListView.separated(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: colorfilter().colorchoicesize,
                                                  separatorBuilder:(BuildContext context,int index)=> const SizedBox(width: 25.0,) ,
                                                  itemBuilder: (BuildContext context,int index){
                                                    return Transform(
                                                      transform: new Matrix4.identity()..scale(1.2),
                                                      child: ChoiceChip(
                                                        label: Text(colorfilter().colorchoices[index]),
                                                        labelStyle: TextStyle(fontFamily: kfontfamily,fontSize: 16.0,color: Colors.white),
                                                        selected: _defaultcolorchipindex==index,
                                                        selectedColor:Color(0xffEF3651),
                                                        backgroundColor:Colors.black.withOpacity(0.3),
                                                        onSelected: (bool value){
                                                          state(()=>_defaultcolorchipindex=value?index:null);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 30.0,),
                                              Text("Size",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                              const SizedBox(height: 20.0,),
                                              SizedBox(
                                                height: 50.0,
                                                child: ListView.separated(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: sizefilter().choicesize,
                                                  separatorBuilder:(BuildContext context,int index)=> const SizedBox(width: 25.0,) ,
                                                  itemBuilder: (BuildContext context,int index){
                                                    return Transform(
                                                      transform: new Matrix4.identity()..scale(1.2),
                                                      child: ChoiceChip(
                                                        label: Text(sizefilter().choices[index]),
                                                        labelStyle: TextStyle(fontFamily: kfontfamily,fontSize: 16.0,color: Colors.white),
                                                        selected: _defaultsizechipindex==index,
                                                        selectedColor:Color(0xffEF3651),
                                                        backgroundColor:Colors.black.withOpacity(0.3),
                                                        onSelected: (bool value){
                                                          state(()=>_defaultsizechipindex=value?index:null);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 30.0,),
                                              Text("Review Rating",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                              const SizedBox(height: 20.0,),
                                              Text("${_currentvalue.round()}"+" star",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                              const SizedBox(height: 20.0,),
                                              Slider(
                                                activeColor: Color(0xffEF3651),
                                                inactiveColor: Colors.grey,
                                                min: 1,
                                                max: 5,
                                                divisions: 4,
                                                value: _currentvalue,
                                                label: _currentvalue.round().toString(),
                                                onChanged: (value){
                                                  state(()=>_currentvalue=value);
                                                },
                                              ),
                                              const SizedBox(height: 40.0,),
                                              Padding(
                                                padding: EdgeInsets.only(left: 20.0,right: 20.0),
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
                                                    onPressed: (){
                                                      setState(() {
                                                        _filtersapplied=true;
                                                      });
                                                      Navigator.pop(context);
                                                      Toast.show("Applied", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                                    },
                                                    child: Text("Apply filters",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 15.0,),
                            GestureDetector(
                              child: filtersandsort(filtername: "Sort",icontype: FontAwesomeIcons.sort,),
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
                                        return Padding(
                                          padding: EdgeInsets.only(top: 10.0,),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children:<Widget> [
                                              Text("Please select an option",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                              const SizedBox(height: 30.0,),
                                              ListTile(
                                                title: Text(sortfilters.sortfilter[0],style: TextStyle(fontFamily: kfontfamily),),
                                                trailing: Radio(
                                                  activeColor: Colors.blue,
                                                  value: sortfilters.sortfilter[0],
                                                  groupValue: _filtervalue,
                                                  onChanged: (value) {
                                                    state((){
                                                      _filtervalue=value;
                                                    });
                                                    setState(() {
                                                      _sortfilterselected=value;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(sortfilters.sortfilter[1],style: TextStyle(fontFamily: kfontfamily),),
                                                trailing: Radio(
                                                  activeColor: Colors.blue,
                                                  value: sortfilters.sortfilter[1],
                                                  groupValue: _filtervalue,
                                                  onChanged: (value) {
                                                    state((){
                                                      _filtervalue=value;
                                                    });
                                                    setState(() {
                                                      _sortfilterselected=value;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(sortfilters.sortfilter[2],style: TextStyle(fontFamily: kfontfamily),),
                                                trailing: Radio(
                                                  activeColor: Colors.blue,
                                                  value: sortfilters.sortfilter[2],
                                                  groupValue: _filtervalue,
                                                  onChanged: (value) {
                                                    state((){
                                                      _filtervalue=value;
                                                    });
                                                    setState(() {
                                                      _sortfilterselected=value;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(sortfilters.sortfilter[3],style: TextStyle(fontFamily: kfontfamily),),
                                                trailing: Radio(
                                                  activeColor: Colors.blue,
                                                  value: sortfilters.sortfilter[3],
                                                  groupValue: _filtervalue,
                                                  onChanged: (value) {
                                                    state((){
                                                      _filtervalue=value;
                                                    });
                                                    setState(() {
                                                      _sortfilterselected=value;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(sortfilters.sortfilter[4],style: TextStyle(fontFamily: kfontfamily),),
                                                trailing: Radio(
                                                  activeColor: Colors.blue,
                                                  value: sortfilters.sortfilter[4],
                                                  groupValue: _filtervalue,
                                                  onChanged: (value) {
                                                    state((){
                                                      _filtervalue=value;
                                                    });
                                                    setState(() {
                                                      _sortfilterselected=value;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(sortfilters.sortfilter[5],style: TextStyle(fontFamily: kfontfamily),),
                                                trailing: Radio(
                                                  activeColor: Colors.blue,
                                                  value: sortfilters.sortfilter[5],
                                                  groupValue: _filtervalue,
                                                  onChanged: (value) {
                                                    state((){
                                                      _filtervalue=value;
                                                      _sortfilterselected=value;
                                                    });
                                                    setState(() {
                                                      _sortfilterselected=value;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0,),
                        SizedBox(
                          height:MediaQuery.of(context).size.height/1.2,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: list.length,
                            itemBuilder: (context,index){
                              return new_product(image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                                  designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['price'],rating: list[index]['rating'],isnew: list[index]['isnew'],docid: list[index].id,favourites: list[index]['favourite']);
                            },
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // here we can manage how the items in the grid will look, 2 items per row, with aspect ratio(size) and space between then and space between the current row and other rows
                              crossAxisCount: 2,
                              childAspectRatio: 0.5,
                              crossAxisSpacing: 70,
                              //mainAxisSpacing: 100.0,
                            ),
                          ),
                        )
                      ],
                    );
                  }
                }
              ):StreamBuilder<List<QueryDocumentSnapshot>>(
                  stream: Stream.fromFuture(_operation(widget.keyword)),
                  builder: (context,AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot){
                    if(snapshot.hasError){
                      return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                    }
                    else if(snapshot.connectionState==ConnectionState.waiting){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: SizedBox(width:100.0,height:100.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                    }else if(snapshot.data.length==0){
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.5,child:
                      Center(child: Text('No products match your search',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                    }else{
                      final List<QueryDocumentSnapshot> list=snapshot.data;
                      return Column(
                        children:<Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: filtersandsort(filtername: "Filter",icontype: FontAwesomeIcons.filter,),
                                onTap: (){
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder:(context)=>Container(
                                      decoration: BoxDecoration(
                                          color:const  Color.fromRGBO(30, 31, 40, 1.0),
                                          borderRadius: BorderRadius.only(topRight:Radius.circular(35.0) ,topLeft: Radius.circular(35.0),)
                                      ),
                                      child: StatefulBuilder(
                                        builder: (BuildContext con,StateSetter state){
                                          return Padding(
                                            padding: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children:<Widget> [
                                                Align(alignment: Alignment.topCenter,child: Text("Filters",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),)),
                                                const SizedBox(height: 20.0,),
                                                Text("Price range",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                                const SizedBox(height: 20.0,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text("\$"+"${_currentvalues.start.round()}",style: TextStyle(fontFamily: kfontfamily,fontSize: 16.0),),
                                                    Text("\$"+"${_currentvalues.end.round()}",style: TextStyle(fontFamily: kfontfamily,fontSize: 16.0),),
                                                  ],
                                                ),
                                                RangeSlider(
                                                    divisions: 1000,
                                                    activeColor: Color(0xffEF3651),
                                                    inactiveColor: Colors.grey,
                                                    values:_currentvalues,
                                                    min: 1,
                                                    max: 5000,
                                                    labels: RangeLabels(
                                                      _currentvalues.start.round().toString(),
                                                      _currentvalues.end.round().toString(),
                                                    ),
                                                    onChanged:(RangeValues value){
                                                      state(()=>_currentvalues=value);
                                                    }
                                                ),
                                                const SizedBox(height: 30.0,),
                                                Text("Colors",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                                const SizedBox(height: 10.0,),
                                                SizedBox(
                                                  height: 50.0,
                                                  child: ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: colorfilter().colorchoicesize,
                                                    separatorBuilder:(BuildContext context,int index)=> const SizedBox(width: 25.0,) ,
                                                    itemBuilder: (BuildContext context,int index){
                                                      return Transform(
                                                        transform: new Matrix4.identity()..scale(1.2),
                                                        child: ChoiceChip(
                                                          label: Text(colorfilter().colorchoices[index]),
                                                          labelStyle: TextStyle(fontFamily: kfontfamily,fontSize: 16.0,color: Colors.white),
                                                          selected: _defaultcolorchipindex==index,
                                                          selectedColor:Color(0xffEF3651),
                                                          backgroundColor:Colors.black.withOpacity(0.3),
                                                          onSelected: (bool value){
                                                            state(()=>_defaultcolorchipindex=value?index:null);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 30.0,),
                                                Text("Size",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                                const SizedBox(height: 20.0,),
                                                SizedBox(
                                                  height: 50.0,
                                                  child: ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: sizefilter().choicesize,
                                                    separatorBuilder:(BuildContext context,int index)=> const SizedBox(width: 25.0,) ,
                                                    itemBuilder: (BuildContext context,int index){
                                                      return Transform(
                                                        transform: new Matrix4.identity()..scale(1.2),
                                                        child: ChoiceChip(
                                                          label: Text(sizefilter().choices[index]),
                                                          labelStyle: TextStyle(fontFamily: kfontfamily,fontSize: 16.0,color: Colors.white),
                                                          selected: _defaultsizechipindex==index,
                                                          selectedColor:Color(0xffEF3651),
                                                          backgroundColor:Colors.black.withOpacity(0.3),
                                                          onSelected: (bool value){
                                                            state(()=>_defaultsizechipindex=value?index:null);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 30.0,),
                                                Text("Review Rating",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                                const SizedBox(height: 20.0,),
                                                Text("${_currentvalue.round()}"+" star",style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                                                const SizedBox(height: 20.0,),
                                                Slider(
                                                  activeColor: Color(0xffEF3651),
                                                  inactiveColor: Colors.grey,
                                                  min: 1,
                                                  max: 5,
                                                  divisions: 4,
                                                  value: _currentvalue,
                                                  label: _currentvalue.round().toString(),
                                                  onChanged: (value){
                                                    state(()=>_currentvalue=value);
                                                  },
                                                ),
                                                const SizedBox(height: 40.0,),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 20.0,right: 20.0),
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
                                                      onPressed: (){
                                                        setState(() {
                                                          _filtersapplied=true;
                                                        });
                                                        Navigator.pop(context);
                                                        Toast.show("Applied", context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                                                      },
                                                      child: Text("Apply filters",style: TextStyle(fontSize: 22.0,fontFamily: kfontfamily),),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 15.0,),
                              GestureDetector(
                                child: filtersandsort(filtername: "Sort",icontype: FontAwesomeIcons.sort,),
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
                                          return Padding(
                                            padding: EdgeInsets.only(top: 10.0,),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children:<Widget> [
                                                Text("Please select an option",style: TextStyle(fontFamily: kfontfamily,fontSize: 20.0),),
                                                const SizedBox(height: 30.0,),
                                                ListTile(
                                                  title: Text(sortfilters.sortfilter[0],style: TextStyle(fontFamily: kfontfamily),),
                                                  trailing: Radio(
                                                    activeColor: Colors.blue,
                                                    value: sortfilters.sortfilter[0],
                                                    groupValue: _filtervalue,
                                                    onChanged: (value) {
                                                      state(()=>_filtervalue=value);
                                                      setState(() {
                                                        _sortfilterselected=value;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text(sortfilters.sortfilter[1],style: TextStyle(fontFamily: kfontfamily),),
                                                  trailing: Radio(
                                                    activeColor: Colors.blue,
                                                    value: sortfilters.sortfilter[1],
                                                    groupValue: _filtervalue,
                                                    onChanged: (value) {
                                                      state(()=>_filtervalue=value);
                                                      setState(() {
                                                        _sortfilterselected=value;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text(sortfilters.sortfilter[2],style: TextStyle(fontFamily: kfontfamily),),
                                                  trailing: Radio(
                                                    activeColor: Colors.blue,
                                                    value: sortfilters.sortfilter[2],
                                                    groupValue: _filtervalue,
                                                    onChanged: (value) {
                                                      state(()=>_filtervalue=value);
                                                      setState(() {
                                                        _sortfilterselected=value;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text(sortfilters.sortfilter[3],style: TextStyle(fontFamily: kfontfamily),),
                                                  trailing: Radio(
                                                    activeColor: Colors.blue,
                                                    value: sortfilters.sortfilter[3],
                                                    groupValue: _filtervalue,
                                                    onChanged: (value) {
                                                      state(()=>_filtervalue=value);
                                                      setState(() {
                                                        _sortfilterselected=value;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text(sortfilters.sortfilter[4],style: TextStyle(fontFamily: kfontfamily),),
                                                  trailing: Radio(
                                                    activeColor: Colors.blue,
                                                    value: sortfilters.sortfilter[4],
                                                    groupValue: _filtervalue,
                                                    onChanged: (value) {
                                                      state(()=>_filtervalue=value);
                                                      setState(() {
                                                        _sortfilterselected=value;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text(sortfilters.sortfilter[5],style: TextStyle(fontFamily: kfontfamily),),
                                                  trailing: Radio(
                                                    activeColor: Colors.blue,
                                                    value: sortfilters.sortfilter[5],
                                                    groupValue: _filtervalue,
                                                    onChanged: (value) {
                                                      state(()=>_filtervalue=value);
                                                      setState(() {
                                                        _sortfilterselected=value;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          SizedBox(
                            height:MediaQuery.of(context).size.height/1.2,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: list.length,
                              itemBuilder: (context,index){
                                return new_product(image_path:list[index]['imageurl'][0],reviews: list[index]['numreviews'],
                                    designer: list[index]['brand'],item: list[index]['name'],original_price: list[index]['price'],rating: list[index]['rating'],isnew: list[index]['isnew'],docid: list[index].id,favourites: list[index]['favourite']);
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // here we can manage how the items in the grid will look, 2 items per row, with aspect ratio(size) and space between then and space between the current row and other rows
                                crossAxisCount: 2,
                                childAspectRatio: 0.5,
                                crossAxisSpacing: 70,
                                //mainAxisSpacing: 100.0,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  }
              ),
            ],
          ),
          ),
        ),
      );
  }
}
