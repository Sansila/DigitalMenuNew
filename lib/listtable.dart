import 'dart:async';
import 'dart:convert';
import 'package:appdigitalmenu/captain.dart';
import 'package:appdigitalmenu/category.dart';
import 'package:appdigitalmenu/jointable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appdigitalmenu/translations.dart';


class TablePage extends StatefulWidget {
  final type; final app;
  TablePage({this.type,this.app});
  @override
  _TablePageState createState() => new _TablePageState();
}

class _TablePageState extends State<TablePage>{
  List data;
  String lastorderid;
  List current;
  Future<String> _getData() async{
      http.Response response = await http.get(
        Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/getTable"),
        headers: {
          "Accept": "application/json"
        }
      );
      this.setState((){
        data = json.decode(response.body);
      });

      return "successfully";
  }

  Future<String> _newOrder(tbl,item) async{
      http.Response response = await http.get(
        Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/makeNewOrder_by_tbl/$tbl"),
        headers: {
          "Accept": "application/json"
        }
      );
      var neworder = response.body;
      if(neworder != null )
      {
        Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new CategoryPage(tbl: tbl, ord: neworder, item: item, app:widget.app)
                      ),
                    );
      }
    return "success";
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String setting = allTranslations.text('language_en');
    String language = allTranslations.text('language_kh');
    String signOut = allTranslations.text('signout');
    List<String> choices = <String>[
      setting,
      language,
      signOut
    ];

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(allTranslations.text('title_list_table'),style: new TextStyle(fontSize: 16.0,fontFamily: "Khmer")),
          backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
          actions: <Widget>[
            new PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                return choices.map((String choice){
                  return new PopupMenuItem<String>(
                    value: choice,
                    child: new Text(choice, style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer")),
                  );
                }).toList();
              },
              icon: new Icon(Icons.settings),
            ),
          ],
        ),
        body: new Container(
          child: new RefreshIndicator(
            child: new GridView.count(
              crossAxisCount: 4,
              padding: new EdgeInsets.all(16.0),
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              children: new List<Widget>.generate(data == null ? 0 : data.length, (index) {
                int r = 0;
                int g = 0;
                int b = 0;
                if(data[index]['Color'] == "Red"){
                  r = 183; g = 32; b = 37;
                }else if(data[index]['Color'] == "Blue"){
                  r = 22; g = 125; b = 191;
                }else if(data[index]['Color'] == "LightGreen"){
                  r = 60; g = 219; b = 66;
                }else if(data[index]['Color'] == "Green"){
                  r = 12; g = 119; b = 8;
                }
                return new GestureDetector(
                  child: new CircleAvatar(
                    child: new Text(data[index]['TableNo'], style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer")),
                    backgroundColor: new Color.fromRGBO(r, g, b, 1.0),
                  ),
                  onTap: (){
                    var tbl = data[index]['TableNo'];
                    var item = "002";
                    if(widget.type == 1 || widget.type == null)
                    {
                      if(data[index]['Status'] == "Busy")
                      {
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new JoinTable(tblno:data[index]['TableNo'],app:widget.app)));
                      }else{
                        _newOrder(tbl,item);
                      }
                    }else{
                      //_getLastOrder(tbl);
                      Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new CaptainPage(tbl:tbl,app:widget.app),
                      ));
                    }
                    
                  },
                );
              }),
            ),
            onRefresh: (){
              _getData();
              return new Future.delayed(const Duration(seconds: 5), () {});
            },
          ),
        ),
      ),
    );
  }
  void choiceAction(String choice){
    
    setState((){});
    if(choice == 'ភាសាអង់គ្លេស' || choice == "English")
    {
      final String language = allTranslations.currentLanguage;
      allTranslations.setNewLanguage(language == 'en' ? 'en' : 'en');
    }else if(choice == 'ភាសាខ្មែរ' || choice == "Khmer")
    {
      final String language = allTranslations.currentLanguage;
      allTranslations.setNewLanguage(language == 'kh' ? 'kh' : 'kh');
    }else{
      Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
    }
  }
}
