import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:appdigitalmenu/translations.dart';

class SubExtraFood extends StatefulWidget {
  final app; final itemid; final ord;
  SubExtraFood({this.app,this.itemid,this.ord});
  @override
  _SubExtraFoodState createState() => new _SubExtraFoodState();
}
class _SubExtraFoodState extends State<SubExtraFood> {
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  var snackBar;
  List current;
  Future<String> _getData() async{
    http.Response response = await http.get(
      Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/getsubItemextra/${widget.itemid}/${widget.ord}"),
      headers: {
        "Accept": "application/json"
      }
    );
    this.setState((){
      current = json.decode(response.body);
    });
    return "";
  }

  Future<String> _saveAll(detailID, qty, course) async{
    final response = await http.get("http://${widget.app}/DigitalService/dynamicController/saveQtyItem/$detailID/$qty/$course", 
      headers: {
        "Accept": "application/json"
      }
    );
    return response.body;
  }
  Future<String> _deleteOrderByStatusOpen(detailID, status) async{
    final response = await http.get("http://${widget.app}/DigitalService/dynamicController/deleteOrderByStatusOpen/$detailID/$status", 
      headers: {
        "Accept": "application/json"
      }
    );
    return response.body;
  }
  Future<String> _clearListView() async{
    current = null;
  }

  Future<String> _deleteItemByID(detailID) async{
    final response = await http.get("http://${widget.app}/DigitalService/dynamicController/deleteItemByID/$detailID", 
      headers: {
        "Accept": "application/json"
      }
    );
    if(response.body == "Success")
    {
      snackBar = new SnackBar(
          content: new Text("Delete success",style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
      _scafoldKey.currentState.showSnackBar(snackBar);
    }else{
      snackBar = new SnackBar(
          content: new Text("Delete false",style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
      _scafoldKey.currentState.showSnackBar(snackBar);
    }
    return response.body;
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
      key: _scafoldKey,
      appBar: new AppBar(
        title: new Text(allTranslations.text('app_title_list_extra'),style: new TextStyle(fontSize: 16.0, fontFamily: "Khmer"),),
        centerTitle: true,
        backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
        actions: <Widget>[
          new PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return choices.map((String choice){
                return new PopupMenuItem<String>(
                  value: choice,
                  child: new Text(choice, style: new TextStyle(fontSize: 12.0, fontFamily: "Khmer"),),
                );
              }).toList();
            },
            icon: new Icon(Icons.settings),
          ),
        ],
      ),
      body: new Container(
        padding: new EdgeInsets.only(top: 20.0),
        child: new ListView.builder(
          itemCount: current == null ? 0 : current.length,
          itemBuilder: (BuildContext context, int i){
            var blob = current[i]['Image'];
            var image;
            final itemid = current[i]['OrderDetailID'];
            if(blob != "")
            {
              image = new Image.memory(base64.decode(blob),fit: BoxFit.cover, height: 60.0, width: 60.0,);
            }else{
              image = new Image.asset('images/download.png', fit: BoxFit.cover, height: 60.0, width: 60.0,);
            }
            var swicthname;
            if(languages == "kh")
            {
              swicthname = current[i]['DescriptionInKhmer'];
            }else{
              swicthname = current[i]['Description'];
            }
            var parentid = current[i]['countAss'];
            return new Dismissible(
              key: new Key(itemid.toString()), // Each Dismissible must contain a Key
              background: new Container(
                padding: new EdgeInsets.fromLTRB(0.0, 40.0, 40.0, 0.0),
                color: Colors.red,
                child: new Text(
                  allTranslations.text('delete'), 
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontFamily: "Khmer"
                  ),
                  textAlign: TextAlign.right,
                ),
              ), // red background behind the item
              onDismissed: (direction) { // Each Dismissible must contain a Key
                _deleteItemByID(itemid);
                setState(() {
                  current.removeAt(itemid);
                });
              },
              child: new Card(
                child: new Column(
                  children: <Widget>[
                    new ButtonTheme.bar(
                      child: new SizedBox(height: 10.0,)
                    ),
                    new ListTile(
                      leading: image,
                      title: new Text("$swicthname", style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                      subtitle: new Row(
                        //mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundColor: Colors.red,
                            child: new IconButton(
                              icon: new Icon(Icons.remove, color: Colors.white,), 
                              onPressed: (){
                                var course = 0;
                                setState((){
                                  if(current[i]['Qty'] > 1)
                                  { 
                                    current[i]['Qty'] -- ;
                                    current[i]['Price'] = current[i]['Qty'] * current[i]['UnitPrice'];
                                    _saveAll(current[i]['OrderDetailID'],current[i]['Qty'],course);
                                  }
                                });
                              },
                            ),
                          ),
                          new Container(
                            child: new Text("${current[i]['Qty']}"),
                            padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          ),
                          new CircleAvatar(
                            backgroundColor: Colors.red,
                            child: new IconButton(
                              icon: new Icon(Icons.add, color: Colors.white), 
                              onPressed: (){
                                var course = 0;
                                setState((){
                                  current[i]['Qty'] ++ ;
                                  current[i]['Price'] = current[i]['Qty'] * current[i]['UnitPrice'];
                                  _saveAll(current[i]['OrderDetailID'],current[i]['Qty'], course);
                                });
                              },
                            ),
                          ),
                          new Container(
                            child: new Text("${current[i]['Price']} "+allTranslations.text('labale_dollar'), style: new TextStyle(color: Colors.red, fontSize: 14.0,fontFamily: "Khmer"),),
                            padding: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          ),
                        ],
                      ),
                      // trailing: new IconButton(
                      //   icon: new Icon(Icons.delete_forever),
                      //   onPressed: (){
                      //     _deleteItemByID(itemid);
                      //     setState(() {
                      //       current.removeAt(itemid);
                      //     });
                      //   },
                      // ),
                    ),
                    new ButtonTheme.bar(
                      child: new SizedBox(height: 10.0,)
                    ),
                  ],
                ),
              ),
            );      
          }
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: new Color.fromRGBO(183,32,37, 1.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new MaterialButton(
              textColor: Colors.white,
              child: new Text(allTranslations.text('delete_all'),style: new TextStyle(fontFamily: "Khmer"), textAlign: TextAlign.center,),
              onPressed: (){
                var second;
                var status = "Open";
                for (var i = 0; i < current.length; i++) {
                  second = i;
                  _deleteOrderByStatusOpen(current[i]['OrderDetailID'], status);
                }
                snackBar = new SnackBar(
                    content: new Text("Loading...",style: new TextStyle(fontFamily: "Khmer"),),
                    duration: new Duration(seconds: second),
                  );
                _scafoldKey.currentState.showSnackBar(snackBar);
                setState(() {
                  _clearListView();                
                });
              },
            )
          ],
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