import 'dart:async';
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appdigitalmenu/translations.dart';

class DetailPage extends StatefulWidget {
   final image;final ord; final tbl; final price; final name; final itemid; final namekh; final app;
   DetailPage({this.image,this.tbl,this.ord,this.price,this.name,this.itemid, this.namekh, this.app});

  @override
  _DetailPageState createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin{
  TabController controller;
  bool _nosugar = false; bool _lesssugar = false; bool _spicy = false;
  bool _nospicy = false; bool _salt = false; bool _nosalt = false;
  String nosugar; String lesssugar; String spicy;
  String nospicy; String salt; String nosalt; String allOption;
  int _counter = 1;
  var total;
  var desc;
  TextEditingController description = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var snackBar;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void _decrementCounter() {
    setState(() {
      if(_counter > 1)
      { 
        _counter--;
      }
    });
  }

  Future<String> _saveDetail() async {
    if(_nosugar == true){nosugar = "NoSugar,";}else{nosugar="";}
    if(_lesssugar == true){lesssugar = "LessSugar,";}else{lesssugar="";}
    if(_spicy == true){spicy = "Spicy,";}else{spicy="";}
    if(_nospicy == true){nospicy = "NoSpicy,";}else{nospicy="";}
    if(_salt == true){salt = "Salt,";}else{salt="";}
    if(_nosalt == true){nosalt = "NoSalt,";}else{nosalt="";}
    allOption = "$nosugar$lesssugar$spicy$nospicy$salt$nosalt";
    desc = description.text;

    final response = await http.post("http://${widget.app}/DigitalService/dynamicController/saveitemDetail", 
      body: {
        "allopt": '$allOption',
        "desc": '$desc',
        "counter": '$_counter',
        "itemid": '${widget.itemid}',
        "orderno": '${widget.ord}',
        "price": '${widget.price}',
        "name": '${widget.name}',
        "namekh": '${widget.namekh}'
      }
    );

    if(response.body == "success")
    {
      snackBar = new SnackBar(
        content: new Text("Order saved",style: new TextStyle(fontFamily: "Khmer"),),
        duration: new Duration(seconds: 3),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }else{
      snackBar = new SnackBar(
        content: new Text("Order save fialed",style: new TextStyle(fontFamily: "Khmer"),),
        duration: new Duration(seconds: 3),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    return "";
   
  }
  
   @override
  void initState() {
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
    var swichtname;
    if(languages == "kh"){
      swichtname = widget.namekh;
    }else{
      swichtname = widget.name;
    }
    String setting = allTranslations.text('language_en');
    String language = allTranslations.text('language_kh');
    String signOut = allTranslations.text('signout');
    List<String> choices = <String>[
      setting,
      language,
      signOut
    ];
    return new Scaffold(
      key: _scaffoldKey,
      appBar:new AppBar(
        title: new Text(allTranslations.text('app_title_detail'),style: new TextStyle(fontSize: 16.0,fontFamily: "Khmer")),
        centerTitle: true,
        backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
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
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.all(8.0),
            //height: 240.0,
            child: widget.image,
          ),
          new Container(
            padding: new EdgeInsets.all(8.0),
            child: new Text(swichtname, style: new TextStyle(fontSize: 14.0, color: Colors.blue,fontFamily: "Khmer"), textAlign: TextAlign.center,),
          ),

          new Container(
            padding: new EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new CircleAvatar(
                        backgroundColor: Colors.red,
                        child: new Icon(Icons.remove, color: Colors.white),
                        ),
                        onTap:_decrementCounter,
                      )
                    ],
                  ),
                ),
                new Column(
                    children: <Widget>[
                      new Text('$_counter', style: new TextStyle(fontSize: 20.0,),)
                    ],
                ),
                new Expanded(
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new CircleAvatar(
                          backgroundColor: Colors.red,
                          child: new Icon(Icons.add, color: Colors.white,),
                        ),
                        onTap: _incrementCounter,
                      )
                    ],
                  ),
                ),
                new Expanded(
                  child: new Column(
                    children: <Widget>[
                      new Text('${widget.price}'+allTranslations.text('labale_dollar'), style: new TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
                
              ],
            ),
          ),

          new Row(
            children: <Widget>[
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Text(allTranslations.text('less_sugar'), style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                    new Checkbox(
                      value: _lesssugar,
                      onChanged: (bool lesssugar) {
                        setState(() {
                          _lesssugar = lesssugar;
                        });
                      },
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Text(allTranslations.text('spicy'), style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                    new Checkbox(
                      value: _spicy,
                      onChanged: (bool spicy) {
                        setState(() {
                          _spicy = spicy;
                        });
                      },
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Text(allTranslations.text('salt'), style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                    new Checkbox(
                      value: _salt,
                      onChanged: (bool salt) {
                        setState(() {
                          _salt = salt;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Text(allTranslations.text('no_sugar'), style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                    new Checkbox(
                      value: _nosugar,
                      onChanged: (bool nosugar) {
                        setState(() {
                          _nosugar = nosugar;
                        });
                      },
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Text(allTranslations.text('no_spicy'), style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                    new Checkbox(
                      value: _nospicy,
                      onChanged: (bool nospicy) {
                        setState(() {
                          _nospicy = nospicy;
                        });
                      },
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Text(allTranslations.text('no_salt'), style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                    new Checkbox(
                      value: _nosalt,
                      onChanged: (bool nosalt) {
                        setState(() {
                          _nosalt = nosalt;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          new Center(
            child: new Padding(
              padding: new EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
              child: new TextField(
                controller: description,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(),
                  labelText: allTranslations.text('detail_desc'),
                ),
                style: new TextStyle(fontSize: 12.0, color: Colors.black54,fontFamily: "Khmer"),
              ),
            ),
          ),
          
          new Container(
            padding: new EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                
                new Expanded(
                  child: new Column(
                    children: <Widget>[
                      new Material(
                        borderRadius: new BorderRadius.circular(36.0),
                        child: new MaterialButton(
                          //padding: new EdgeInsets.fromLTRB(85.0, 0.0,85.0, 0.0),
                          minWidth: 200.0,
                          height: 40.0,
                          onPressed:(){ 
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              child: new AlertDialog(
                                  title: new Center(child: new Text(allTranslations.text('message'),style: new TextStyle(fontFamily: "Khmer"),)),
                                  content: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children : <Widget>[
                                      new Expanded(
                                        child: new Text(
                                          allTranslations.text('msg_ask_ord'),
                                          textAlign: TextAlign.center,
                                          style: new TextStyle(
                                            color: Colors.red,
                                            fontFamily: "Khmer"
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  actions: <Widget>[
                                    new FlatButton(
                                        child: new Text(allTranslations.text('msg_cancel'),style: new TextStyle(fontFamily: "Khmer"),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    new FlatButton(
                                        child: new Text(allTranslations.text('msg_ok'),style: new TextStyle(fontFamily: "Khmer"),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _saveDetail();
                                        })
                                  ],
                                ),
                            );
                          },
                          child: new Text(allTranslations.text('btn_save'), style: new TextStyle(color: Colors.white, fontSize: 14.0,fontFamily: "Khmer"),),
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
                new Expanded(
                  child: new Column(
                    children: <Widget>[
                      new Material(
                        borderRadius: new BorderRadius.circular(36.0),
                        child: new MaterialButton(
                          //padding: new EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
                          minWidth: 200.0,
                          height: 40.0,
                          onPressed: (){},
                          child: new Text(allTranslations.text('msg_cancel'), style: new TextStyle(color: Colors.white, fontSize: 14.0,fontFamily: "Khmer"),),
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
                
              ],
            ),
          )
        ],
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

