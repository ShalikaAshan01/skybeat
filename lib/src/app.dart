import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skybeat/src/root.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueGrey,
            shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(55)
            )
        ),
        backgroundColor: Colors.black87,
          buttonColor: Colors.white,
          fontFamily: 'Arvo',
          unselectedWidgetColor: Colors.white,
          primaryTextTheme:
          TextTheme(
              caption: TextStyle(color: Colors.white,),
            title: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,decoration: TextDecoration.none),
            subtitle: TextStyle(color: Colors.white54 ,decoration: TextDecoration.none)
          ),

      ),
        home: Root()
    );
  }
}