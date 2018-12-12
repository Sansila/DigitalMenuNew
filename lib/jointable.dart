import 'dart:async';
import 'dart:convert';
import 'package:appdigitalmenu/category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appdigitalmenu/translations.dart';

// void main(){
//   runApp(new MaterialApp(
//     home: new JoinTable(),
//   ));
// }

class JoinTable extends StatefulWidget {
  final String tblno; final app;
  JoinTable({this.tblno, this.app});
  @override
  _JoinTableState createState() =>new _JoinTableState(tblno:tblno);
}

class _JoinTableState extends State<JoinTable> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final String tblno;
  final String item = '002';
  _JoinTableState({this.tblno});

  List data;
  Future<String> _getData() async{
      http.Response response = await http.post(
        Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/ListOrdersAll/$tblno"),
        headers: {
          "Accept": "application/json"
        }
      );
      this.setState((){
        data = json.decode(response.body);
      });
      return "successfully";
  }

  Future<String> _newOrder() async{
      http.Response response = await http.post(
        Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/makeNewOrder_by_tbl/$tblno"),
        headers: {
          "Accept": "application/json"
        }
      );
      var neworder = response.body;
      if(neworder != null )
      {
        Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new CategoryPage(tbl:tblno, ord:neworder,item:item,app:widget.app)
                      ),
                    );
      }
    return "success";
  }
  

  TabController controller;

  @override
  void initState() {
    _getData();
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
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

    return  new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(allTranslations.text('app_title_join'),style: new TextStyle(fontSize: 16.0,fontFamily: "Khmer")),
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
        bottom: new TabBar(
          controller: controller,
          unselectedLabelStyle:null,
          tabs: [
            new Tab(
              child: new Container(
                child: new Text(allTranslations.text('tbl_no')+' $tblno', 
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
                child: new Material(
                  borderRadius: new BorderRadius.circular(30.0),
                  child: new MaterialButton(
                    onPressed: (){_newOrder(); },
                    child: new Text(allTranslations.text('make_new_order'), style: new TextStyle(
                        color: Colors.red, 
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        fontFamily: "Khmer"
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                ),
                width: 200.0,
              ),
            ),
          ],
        ),
      ),
      //endDrawer: new Drawer(),
      body: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(allTranslations.text('ask_join'), style: new TextStyle(fontSize: 14.0,fontFamily: "Khmer"),),
            leading: new Icon(Icons.add_circle_outline),
          ),
          new ListTile(
            title: new Text(allTranslations.text('ask_join_desc'), style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer")),
          ),
          new ListTile(
            title: new Text(allTranslations.text('list_order'), style: new TextStyle(fontSize: 14.0,fontFamily: "Khmer"),),
            leading: new Icon(Icons.add_circle_outline),
          ), 
          new Expanded(
            child: new RefreshIndicator(
              child: new ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index){
                  var orderno = data[index]['orderno'];
                  var date = data[index]['date'];
                  return new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.casino),
                      title: new Text(allTranslations.text('ord_no')+': $orderno', style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),),
                      subtitle: new Text(allTranslations.text('date')+': $date', style: new TextStyle(fontSize: 11.0,fontFamily: "Khmer")),
                      trailing: new Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new CategoryPage(tbl:tblno, ord:orderno,item:item,app: widget.app,)
                        ),
                      ),
                    ),
                  );
                },
              ),
              onRefresh: (){
                _getData();
                return new Future.delayed(const Duration(seconds: 5), () {});
              },
            ),
          ),
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