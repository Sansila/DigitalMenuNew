import 'dart:async';

import 'package:appdigitalmenu/listtable.dart';
import 'package:appdigitalmenu/login.dart';
import 'package:flutter/material.dart';
import 'package:appdigitalmenu/translations.dart';

Future main() async {
  await allTranslations.init();
  runApp( new MyHomePage());
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
      routes: <String, WidgetBuilder>{
        '/LoginPage': (BuildContext context) => new LoginPage(),
        '/TablePage': (BuildContext context) => new TablePage(),
      },
    );
  }
}