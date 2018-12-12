
import 'dart:async';
//import 'dart:convert';
import 'package:appdigitalmenu/captain.dart';
import 'package:appdigitalmenu/currentorder.dart';
import 'package:appdigitalmenu/option/Product.dart';
import 'package:appdigitalmenu/option/ShoppingListItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appdigitalmenu/translations.dart';

class ListOptionPage extends StatefulWidget {
  final List<Product> product;
  final itemid; final app; final p;
  ListOptionPage({
    Key key, 
    this.product, 
    this.itemid, 
    this.app,
    this.p,
    }) :super(key: key);

  @override
  _ListOptionPageState createState() => new _ListOptionPageState();
}

class _ListOptionPageState extends State<ListOptionPage> {
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  Future<String> _saveAll(detailID, opt) async{
      final response = await http.post("http://${widget.app}/DigitalService/dynamicController/saveItemOption",
        body: {
          "id": '$detailID',
          "opt": '$opt'
        }
      );
      if(response.body == "Success")
      {
        final snackBar = new SnackBar(
          content: new Text("Success"),
          duration: new Duration(seconds: 3),
        );
        _scafoldKey.currentState.showSnackBar(snackBar);
      }else{
        final snackBar = new SnackBar(
          content: new Text("False"),
          duration: new Duration(seconds: 3),
        );
        _scafoldKey.currentState.showSnackBar(snackBar);
      }
      setState(() {
        if(widget.p == "cur")
        {
          Navigator.of(context).pop(new MaterialPageRoute(
            builder: (BuildContext context) => new CurrentOrderPage(),
          ));
        }else{
          Navigator.of(context).pop(new MaterialPageRoute(
            builder: (BuildContext context) => new CaptainPage(),
          ));
        }     
      });
      return response.body;
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
    var body = new Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: <Widget>[
             new Expanded(child: new ListView(
               padding: new EdgeInsets.symmetric(vertical: 8.0),
               children: widget.product.map((Product product) {
                 return new ShoppingItemList(product);
               }).toList(),
             )),
           ],
         ); 
 
      return new Scaffold(
        key: _scafoldKey,
        appBar: new AppBar(
          title: new Text(allTranslations.text('app_title_foodopt'),style: new TextStyle(fontSize: 16.0,fontFamily: "Khmer")),
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
       body: new Container(
          child: body
       ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          var opt = new List();
          for (Product p in widget.product) {
            if (p.isCheck)
            {
              opt.add(p.isValue);
            }
          }
          _saveAll(widget.itemid, opt);
        },
        child: new Icon(Icons.check),
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
