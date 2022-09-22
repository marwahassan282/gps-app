import 'package:flutter/material.dart';
import 'package:googlemaps/home.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName:(c)=>HomeScreen(),
      },
    );
  }
}


