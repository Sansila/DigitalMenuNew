import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appdigitalmenu/translations.dart';

class SummaryOrderPage extends StatefulWidget {
  final ord; final tbl; final app;
  SummaryOrderPage({this.tbl, this.ord, this.app});
  @override
  _SummaryOrderPageState createState() =>new _SummaryOrderPageState();
}

class _SummaryOrderPageState extends State<SummaryOrderPage> with SingleTickerProviderStateMixin {
  TabController controller;
  List current;
  Future<List> _getCurrentOrder() async{
    final response = await http.get("http://${widget.app}/DigitalService/dynamicController/getOrderSummary/${widget.ord}", 
      headers: {
        "Accept": "application/json"
      }
    );
    this.setState((){
      current = json.decode(response.body);
    });
    return current;
  }

  @override
  void initState() {
    _getCurrentOrder();
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String languages = allTranslations.currentLanguage;
    String setting = allTranslations.text('language_en');
    String language = allTranslations.text('language_kh');
    String signOut = allTranslations.text('signout');
    List<String> choices = <String>[
      setting,
      language,
      signOut
    ];
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(allTranslations.text('app_title_summary'),style: new TextStyle(fontSize: 16.0,fontFamily: "Khmer")),
        backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
        centerTitle: true,
        actions: <Widget>[
          new PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return choices.map((String choice){
                return new PopupMenuItem<String>(
                  value: choice,
                  child: new Text(choice, style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                );
              }).toList();
            },
            icon: new Icon(Icons.settings),
          ),
        ],
        bottom: new TabBar(
          controller: controller,
          tabs:[
            new Tab(
              child: new Container(
                child: new Text(allTranslations.text('tbl_no')+' ${widget.tbl}', 
                  style: new TextStyle(
                    color: new Color.fromRGBO(255,255,255, 1.0),
                    fontSize: 12.0,
                    fontFamily: "Khmer"
                  ),
                  textAlign: TextAlign.center,
                ),
                padding: new EdgeInsets.all(10.0),
                width: 200.0,
              ),
            ),
            new Tab(
              child: new Container(
                child: new Text(allTranslations.text('ord_no')+': ${widget.ord}', 
                  style: new TextStyle(
                    color: new Color.fromRGBO(255,255,255, 1.0),
                    fontSize: 12.0,
                    fontFamily: "Khmer"
                  ),
                  textAlign: TextAlign.center,
                ),
                padding: new EdgeInsets.all(10.0),
                width: 200.0,
              ),
            ),
          ],
        ),
      ),
      body: new ListView.builder(
        itemCount: current == null ? 0 : current.length,
        itemBuilder: (BuildContext context, int i){
          var blob = current[i]['Picture'];
          var image;
          if(blob != "")
          {
            image = new Image.memory(base64.decode(blob), fit: BoxFit.cover, height: 60.0, width: 60.0,);
          }else{
            image = new Image.asset('images/download.png', fit: BoxFit.cover, height: 60.0, width: 60.0,);
          }
          var couse;
          if(current[i]['Course'] == null)
          {
            couse = 0;
          }else{
            couse = current[i]['Course'];
          }
          var swicthname;
          if(languages == "kh")
          {
            swicthname = current[i]['DescriptionInKhmer'];
          }else{
            swicthname = current[i]['Description'];
          }
          return new Card(
          child: new Column(
            children: <Widget>[
              new ButtonTheme.bar(
                child: new Container(
                  child: new SizedBox(height: 15.0,)
                ),
              ),
              new ListTile(
                leading: image,
                title: new Text("$swicthname", style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
              ),
              new ButtonTheme.bar(
                child: new Container(
                  child: new ButtonBar(
                    children: <Widget>[
                      new Container(
                        child: new Text(allTranslations.text('quantity')+': ${current[i]["Qty"]}', style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                        padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      ),
                      new Container(
                        child: new Text(allTranslations.text('price')+": "+current[i]['UnitPrice'], style: new TextStyle(color: Colors.red,fontSize: 12.0,fontFamily: "Khmer"),),
                        padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      ),
                      new Container(
                        child: new Text(allTranslations.text('course')+": $couse", style: new TextStyle(color: Colors.red,fontSize: 12.0,fontFamily: "Khmer"),),
                        padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        );
        }, 
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