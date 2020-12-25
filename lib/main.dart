import 'package:band_names/src/pages/home_page.dart';
import 'package:band_names/src/pages/status_page.dart';
import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocketService())
      ],
      child: MaterialApp(
        title: 'Band Names',
        debugShowCheckedModeBanner: false,
        initialRoute: "home",
        routes: {
          "home" : (_) => HomePage(),
          "status" : (_) => StatusPage(),
        }, 
      ),
    );
  }
}