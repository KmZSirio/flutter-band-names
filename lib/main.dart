import 'package:band_names/src/pages/home_page.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Band Names',
      debugShowCheckedModeBanner: false,
      initialRoute: "home",
      routes: {
        "home" : (_) => HomePage()
      }, 
    );
  }
}