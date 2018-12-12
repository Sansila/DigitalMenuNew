import 'dart:async';
import 'dart:convert';
import 'package:appdigitalmenu/category.dart';
import 'package:flutter/material.dart';
import 'package:appdigitalmenu/translations.dart';
import 'package:http/http.dart' as http;

class ExtrafoodPage extends StatefulWidget {
  final app; final id; 
  final name; final namekh; 
  final qty; final price;
  final ord; final tbl;
  ExtrafoodPage({
    this.app,
    this.id,
    this.name,
    this.namekh,
    this.qty,
    this.price,
    this.tbl,
    this.ord
    });
  @override
  _ExtrafoodPageState createState() => new _ExtrafoodPageState();
}
class _ExtrafoodPageState extends State<ExtrafoodPage> {
  
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  List extra;
  List sub;
  var userList;
  var snackBar;
  Future<String> _getLastOrder() async{
      final responses = await http.get("http://${widget.app}/DigitalService/dynamicController/getListforExtra/${widget.tbl}/${widget.ord}", 
      headers: {
        "Accept": "application/json"
      });
      this.setState((){
        extra = json.decode(responses.body);
      });
    return "";
  }
  Future<String> _saveExtra(id) async{
    final responses = await http.post("http://${widget.app}/DigitalService/dynamicController/saveExtra", 
      body: {
        "itemid": "${widget.id}",
        "ord": "${widget.ord}",
        "assid": "$id",
        "name": "${widget.name}",
        "namekh": "${widget.namekh}",
        "qty": "${widget.qty}",
        "price": "${widget.price}",
      });
      if(responses.body == "Success")
      {
        snackBar = new SnackBar(
          content: new Text("Save success",style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
        _scafoldKey.currentState.showSnackBar(snackBar);

        Navigator.of(context).pop(new MaterialPageRoute(
            builder: (BuildContext context) => new CategoryPage(),
        ));
      }else{
        snackBar = new SnackBar(
          content: new Text("Save false",style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
        _scafoldKey.currentState.showSnackBar(snackBar);
      }
  }

  @override
  void initState() {
    _getLastOrder();
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

    //print(widget.itemid);
    

    return new Scaffold(
      key: _scafoldKey,
      appBar: new AppBar(
        title: new Text(allTranslations.text('app_title_extra'),style: new TextStyle(fontFamily: "Khmer",fontSize: 16.0),),
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
      body: ListView.builder(
        itemCount: extra == null ? 0 : extra.length,
        itemBuilder: (context, index) {
          var price = extra[index]['price'];
          var blob = extra[index]['image'];
          var image;

          if(blob != "")
          {
            image = new Image.memory(base64.decode(blob),fit: BoxFit.cover, height: 60.0, width: 70.0,);
          }else{
            image = new Image.asset('images/download.png',fit: BoxFit.cover, height: 60.0, width: 70.0,);
          }
          var swicthname;
          if(languages == "kh")
          {
            swicthname = extra[index]['namekh'];
          }else{
            swicthname = extra[index]['name'];
          }
          return new Card(
            child: new ListTile(
              leading: image,
              title: new Text(swicthname,
                style: new TextStyle(fontSize: 12.0, fontFamily: "Khmer"),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: new Text('$price USD', style: new TextStyle(color: Colors.red, fontSize: 16.0,),),
              trailing: new IconButton(
                icon: new Icon(Icons.add_circle),
                onPressed: (){
                  _saveExtra(extra[index]['id']);
                },
              ),
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

