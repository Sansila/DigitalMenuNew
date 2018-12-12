import 'dart:async';
import 'dart:convert';
import 'package:appdigitalmenu/subextrafood.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:appdigitalmenu/option/Product.dart';
import 'package:appdigitalmenu/listfoodoption.dart';
import 'package:appdigitalmenu/translations.dart';

enum Course {
  one,
  two,
  three,
  four,
  five,
}

class CurrentOrderPage extends StatefulWidget {
  final tbl; final ord; final item; final app;
  CurrentOrderPage({this.tbl, this.ord, this.item, this.app});
  @override
   _CurrentOrderPageState createState() => new _CurrentOrderPageState();
}
  
  class _CurrentOrderPageState extends State<CurrentOrderPage> with SingleTickerProviderStateMixin{
    //List<Map> _orderNo = [{"id":0,"name":"<New>"}];
    List _orderNo = List();
    List current;
    var order;
    TabController controller;
    int currentTab = 1;
    final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
    var snackBar;
    var p = "cur";

  Future<String> _getLastOrder(tbl) async{
      final responses = await http.get("http://${widget.app}/DigitalService/dynamicController/getCurrentOrderbyID/${widget.ord}/$tbl", 
      headers: {
        "Accept": "application/json"
      });
      this.setState((){
        current = json.decode(responses.body);
      });
    return "";
  }

  Future<String> _getData() async{
    http.Response response = await http.get(
      Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/ListOrdersAll/${widget.tbl}"),
      headers: {
        "Accept": "application/json"
      }
    );
    this.setState((){
      _orderNo = json.decode(response.body);
    });
    return "";
  }

  Future<String> _getitembyord(tbl,order) async{
    final response = await http.post("http://${widget.app}/DigitalService/dynamicController/getCurrentOrderbyID/$order/$tbl", 
      headers: {
        "Accept": "application/json"
      }
    );
      this.setState((){
        current = json.decode(response.body);
      });
      return "";
  }

  Future<String> _clearListView() async{
    current = null;
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

  Future<String> _deleteItemByID(detailID) async{
    final response = await http.get("http://${widget.app}/DigitalService/dynamicController/deleteItemByID/$detailID", 
      headers: {
        "Accept": "application/json"
      }
    );
    if(response.body == "Success")
    {
      snackBar = new SnackBar(
          content: new Text("Order deleted",style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
      _scafoldKey.currentState.showSnackBar(snackBar);
    }else{
      snackBar = new SnackBar(
          content: new Text("Order delete failed",style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
      _scafoldKey.currentState.showSnackBar(snackBar);
    }
    return response.body;
  }
  
  @override
  void initState() {
    _getData();
    _getLastOrder(widget.tbl);
    controller = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String languages = allTranslations.currentLanguage;
    ValueNotifier<Course> _selectedItem = new ValueNotifier<Course>(null);
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
        title: new Text(allTranslations.text('app_title_current'),style: new TextStyle(fontSize: 16.0,fontFamily: "Khmer")),
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
          unselectedLabelStyle:null,
          tabs: [
            new Tab(
              child: new Container(
                child: new Text(allTranslations.text('tbl_no')+': ${widget.tbl}', 
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
                child: new DropdownButton<String>(
                  isDense: true,
                  hint: new Text(allTranslations.text('select_ord'), style: new TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    fontFamily: "Khmer",
                    ),
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      order = newValue;
                    });
                    _getitembyord(widget.tbl, order);
                  },
                  items: _orderNo.map((map) {
                    return new DropdownMenuItem(
                      value: map["orderno"].toString(),
                      child: new Text(
                        allTranslations.text('ord_no')+': ${map["orderno"]}', 
                        style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
                //padding: new EdgeInsets.all(10.0),
              ),
            ),
          ],
        ),
      ),
      body: new Container(
        //padding: new EdgeInsets.only(top: 20.0),
        child: new ListView.builder(
          itemCount: current == null ? 0 : current.length,
          itemBuilder: (BuildContext context, int i){
            var blob = current[i]['Image'];
            var image;
            final itemid = current[i]['OrderDetailID'];
            if(blob != "")
            {
              image = new Image.memory(base64.decode(blob),fit: BoxFit.cover, height: 100.0, width: 100.0,);
            }else{
              image = new Image.asset('images/download.png', fit: BoxFit.cover, height: 100.0, width: 100.0,);
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
                      child: new SizedBox(height: 20.0,)
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
                    ),
                    new ButtonTheme.bar(
                      child: new ButtonBar(
                        children: <Widget>[
                          new PopupMenuButton<Course>(
                            child: new Text(allTranslations.text('foodcourse'),style: new TextStyle(fontSize: 12.0,color: Colors.blue,fontWeight: FontWeight.w600,fontFamily: "Khmer")),
                            itemBuilder: (BuildContext context) {
                              return new List<PopupMenuEntry<Course>>.generate(
                                Course.values.length,
                                (int index) {
                                  return new PopupMenuItem(
                                    value: Course.values[index],
                                    child: new AnimatedBuilder(
                                      child: new Text(Course.values[index].toString()),
                                      animation: _selectedItem,
                                      builder: (BuildContext context, Widget child) {
                                        return new RadioListTile<Course>(
                                          value: Course.values[index],
                                          groupValue: _selectedItem.value,
                                          title: child,
                                          onChanged: (Course value) {
                                            _selectedItem.value = value;
                                            var course = index;
                                            _saveAll(current[i]['OrderDetailID'],current[i]['Qty'], course + 1);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          new FlatButton(
                            child: new Text(allTranslations.text('foodoption'),style: new TextStyle(color: Colors.blue,fontSize: 12.0,fontWeight: FontWeight.w600,fontFamily: "Khmer")),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context)=> new ListOptionPage(product:
                                          [
                                            new Product(allTranslations.text('less_sugar'),'O',false,'LessSugar'),
                                            new Product(allTranslations.text('no_sugar'),'O',false,'NoSugar'),
                                            new Product(allTranslations.text('spicy'),'O',false,'Spicy'),
                                            new Product(allTranslations.text('no_spicy'),'O',false,'NoSpicy'),
                                            new Product(allTranslations.text('salt'),'O',false,'Salt'),
                                            new Product(allTranslations.text('no_salt'),'O',false,'NoSalt'),
                                          ],
                                          itemid: current[i]['OrderDetailID'],
                                          app:widget.app,
                                          p:p
                                          ),
                              ));
                            },
                          ),
                          new FlatButton(
                            child: new Text(allTranslations.text('foodextra')+'($parentid)',style: new TextStyle(fontSize: 12.0,color: Colors.blue,fontWeight: FontWeight.w600,fontFamily: "Khmer")),
                            onPressed: (){
                              Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context)=> new SubExtraFood(app:widget.app,itemid:itemid,ord:widget.ord),
                              ));
                            },
                          ),
                        ],
                      ),
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