import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vardrobe/Services/authentication_and_userprovider.dart';
import 'Screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>authenticationanduserprovider())
      ],
      child: MaterialApp(

        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color.fromRGBO(30, 31, 40, 0.8),
          canvasColor: Colors.transparent,
          visualDensity:VisualDensity.adaptivePlatformDensity,
        ),
        home:splash_screen(),
      ),
    );
  }
}
