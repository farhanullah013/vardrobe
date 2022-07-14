import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:vardrobe/Screens/search_result_screen.dart';
import 'package:vardrobe/Services/algolia_search.dart';
import 'package:vardrobe/Widgets/sort_filters_and_catsearch.dart';
import 'package:vardrobe/Widgets/constants.dart';
import 'package:algolia/algolia.dart';

class search_screen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<search_screen> {

  List<dynamic> _categories =sortfilters().cats;
  String _search="";
  final Algolia _algoliaApp = algolia_search.algolia;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("products").query(input).setQueryType(QueryType.prefixAll).setHitsPerPage(10);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const  Color.fromRGBO(30, 31, 40, 0.7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft,color: Colors.white,size: 22.0,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        elevation: 8.0,
        backgroundColor:const  Color.fromRGBO(30, 31, 40, 0.9),
        title: Form(
          child: Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: TextFormField(
              onChanged: (text){
                if(text.isEmpty){
                  Toast.show('Please enter something to search', context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                  setState(() {
                    _search="";
                  });
                }
               else if(!text.contains(new RegExp(r'^[A-Za-z ]+$'))){
                  Toast.show("Only alphabets allowed", context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                }else{
                 setState(() {
                   _search=text.toLowerCase();
                 });
                }
              },
              onFieldSubmitted: (text) async {
                if(text.isEmpty){
                  Toast.show('Please enter something to search', context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                }else if(!text.contains(new RegExp(r'^[A-Za-z ]+$'))){
                  Toast.show("Only alphabets allowed", context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                }else if(text.length<4){
                  Toast.show("Please enter more than 4 words", context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                }else{
                  List<dynamic> categories =sortfilters().cats;
                  if(categories.contains(text.toLowerCase())){
                    Navigator.push(context, PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                          return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                        },
                        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                          return search_result_screen(iscat: true,keyword: text,);
                        }
                    ));
                  }else{
                    Navigator.push(context, PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                          return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                        },
                        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                          return search_result_screen(iscat:false,keyword: text,);
                        }
                    ));
                  }
                }
              },
              maxLength: 30,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textInputAction: TextInputAction.search,
              autofocus: true,
              decoration: InputDecoration(
                counter: Container(),
                hintText: 'T-shirt',
                hintStyle: TextStyle(
                  fontSize: 18.0,
                  fontFamily: kfontfamily,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color.fromRGBO(30, 31, 40, 0.7), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Color.fromRGBO(30, 31, 40, 0.7), width: 2.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0),
          child: Column(
            children: <Widget>[
              StreamBuilder<List<AlgoliaObjectSnapshot>>(
                stream: Stream.fromFuture(_operation(_search)),
                builder:(context,AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot){
                  if(snapshot.hasError){
                    print(snapshot.error.toString());
                    return Text('Something went wrong',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),);
                  }else if(snapshot.connectionState==ConnectionState.waiting){
                    return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                    Center(child: SizedBox(width:70.0,height:70.0,child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Colors.amber,))));
                  }else if(snapshot.data.length==0){
                    String matched;
                    _categories.forEach((element) {
                      if(element.contains(_search)){
                        matched=element;
                      }
                    });
                    if(matched!=null){
                      return ListTile(
                        title: Text(matched,style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),),
                        trailing: Icon(Icons.arrow_right),
                        onTap: (){
                          Navigator.push(context, PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                              },
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                return search_result_screen(iscat: true,keyword: matched,);
                              }
                          ));
                        },
                      );
                    }else{
                      return Container(width: double.infinity,height:MediaQuery.of(context).size.height/1.6,child:
                      Center(child: Text('No products match your search',style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0),)));
                    }
                  }else{
                    List<AlgoliaObjectSnapshot> searchesmatched = snapshot.data;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.separated(
                        separatorBuilder: (context,_){
                          return Divider(
                            indent: 4.0,
                            endIndent: 4.0,
                            thickness: 1.5,
                            color: Color(0xffE72A28),
                          );
                        },
                        itemCount: searchesmatched.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context,index){
                          return ListTile(
                            title: Text(searchesmatched[index].data['search'],style: TextStyle(fontFamily: kfontfamily,fontSize: 18.0)),
                            trailing: Icon(Icons.arrow_right),
                            onTap: (){
                              Navigator.push(context, PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 500),
                                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,Widget child){
                                    return effectMap[PageTransitionType.rippleRightUp](Curves.linear,animation,secondaryAnimation,child);
                                  },
                                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                    return search_result_screen(iscat: false,keyword: searchesmatched[index].data['search'],);
                                  }
                              ));
                            },
                          );
                        },
                      ),
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
