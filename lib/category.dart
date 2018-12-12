import 'dart:async';
import 'dart:convert';
import 'package:appdigitalmenu/currentorder.dart';
import 'package:appdigitalmenu/listtable.dart';
import 'package:appdigitalmenu/summaryorder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appdigitalmenu/detail.dart';
import 'package:dio/dio.dart';
import 'package:appdigitalmenu/translations.dart';
import 'package:appdigitalmenu/extrafood.dart';

class CategoryPage extends StatefulWidget {
  final tbl; final ord; final item; final app;
  CategoryPage({this.tbl, this.ord, this.item, this.app});

  @override
  _CategoryPageState createState() => new _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var snackBar;
  List<dynamic> cate; 
  List categorylist;
  var qtyord = 0;
  List<dynamic> cateall;
  var current = 0;

  Future<String> _getCate(item) async{
      http.Response response = await http.get(
        Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/getListItembyID/$item"),
        headers: {
          "Accept": "application/json"
        }
      );
      this.setState((){
        cate = json.decode(response.body);
      });

      final responses = await http.get("http://${widget.app}/DigitalService/dynamicController/getCountCurrentOrderbyID/${widget.ord}/${widget.tbl}", 
      headers: {
        "Accept": "application/json"
      });
      this.setState((){
        current = json.decode(responses.body);
      });

      return "successfully";
  }

  Future<String> _getAllItem() async{
      http.Response response = await http.get(
        Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/getAllListItem"),
        headers: {
          "Accept": "application/json"
        }
      );
      this.setState((){
        cateall = json.decode(response.body);
      });
      return "successfully";
  }

  Future<String> _getCateByID(id) async{
      http.Response response = await http.get(
        Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/getListItembyID/$id"),
        headers: {
          "Accept": "application/json"
        }
      );
      this.setState((){
        cate = json.decode(response.body);
      });
      return "successfully";
  }

  Future<String> _getCateList() async{
      http.Response response = await http.get(
        Uri.encodeFull("http://${widget.app}/DigitalService/dynamicController/left_menu"),
        headers: {
          "Accept": "application/json"
        }
      );
      this.setState((){
        categorylist = json.decode(response.body);
      });
      return "successfully";
  }

  Future<String> _saveFromCategory(price,itemid,name,namekh,qty) async{

    final response = await http.post("http://${widget.app}/DigitalService/dynamicController/saveFromCategory", 
      body: {
        "qty": "$qty",
        "itemid": "$itemid",
        "ord": "${widget.ord}",
        "price": "$price",
        "name": "$name",
        "namekh": "$namekh"
      }
    );
    if(response.body == "success")
    {
      snackBar = new SnackBar(
        content: new Text("Order saved",style: new TextStyle(fontFamily: "Khmer"),),
        duration: new Duration(seconds: 3),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      final responses = await http.get("http://${widget.app}/DigitalService/dynamicController/getCountCurrentOrderbyID/${widget.ord}/${widget.tbl}", 
      headers: {
        "Accept": "application/json"
      });
      this.setState((){
        current = json.decode(responses.body);
      });

    }else{
      snackBar = new SnackBar(
        content: new Text("Order save failed",style: new TextStyle(fontFamily: "Khmer"),),
        duration: new Duration(seconds: 3),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    return response.body;
    
  }
  TabController controller;

  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text(allTranslations.text('app_title_menu'), style: new TextStyle(fontSize: 16.0,fontFamily: "Khmer"),);

  _CategoryPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _getCate(widget.item);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  Future _getExtra(app,itemid,description,descriptionkh,price,ord,tbl) async{
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context)=> new ExtrafoodPage(
        app:app,
        id:itemid,
        name:description,
        namekh:descriptionkh,
        qty:1,
        price:price,
        ord:ord,
        tbl:tbl
      ),
    ));
  }

  @override
  void initState() {
    _getCate(widget.item);
    _getCateList();
    _getAllItem();
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
  }
  void _clearCounterm() {
    setState(() {
      qtyord--;
    });
  }

  Widget _buildBar(BuildContext context) {

    String setting = allTranslations.text('language_en');
    String language = allTranslations.text('language_kh');
    String summry = allTranslations.text('summry');
    String gotable = allTranslations.text('gotable');
    String signOut = allTranslations.text('signout');
    List<String> choices = <String>[
      setting,
      language,
      summry,
      gotable,
      signOut
    ];

    return new AppBar(
      title: _appBarTitle,
      backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
      actions: <Widget>[
        new IconButton(
          onPressed: _searchPressed,
          tooltip: allTranslations.text('label_search'),
          icon:_searchIcon,
        ),
        new PopupMenuButton<String>(
          onSelected: choiceAction,
          itemBuilder: (BuildContext context){
            return choices.map((String choice){
              return new PopupMenuItem<String>(
                value: choice,
                child: new Text(choice,style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer")),
              );
            }).toList();
          },
          icon: new Icon(Icons.settings),
        ),
        new IconButton(
          icon: new Icon(Icons.menu),
          onPressed: (){
            _scaffoldKey.currentState.openEndDrawer();
          },
        ),
      ],
      bottom: new TabBar(
          controller: controller,
          unselectedLabelStyle:null,
          tabs: [
            new Tab(
              child: new Container(
                child: new Text(allTranslations.text('tbl_no_cat')+': ${widget.tbl}', 
                  style: new TextStyle(
                    color: new Color.fromRGBO(255,255,255, 1.0),
                    fontSize: 12.0,
                    fontFamily: "Khmer"
                  ),
                  textAlign: TextAlign.center,
                ),
                padding: new EdgeInsets.all(10.0),
                //width: 200.0,
              ),
            ),
            new Tab(
              child: new Container(
                child: new Text(allTranslations.text('ord_no_cat')+': ${widget.ord}', 
                  style: new TextStyle(
                    color: new Color.fromRGBO(255,255,255, 1.0),
                    fontSize: 12.0,
                    fontFamily: "Khmer"
                  ),
                  textAlign: TextAlign.center,
                ),
                padding: new EdgeInsets.all(10.0),
                //width: 200.0,
              ),
            ),
            new Tab(
              child: new Container(
                child: new ListTile(
                  title: new Text(allTranslations.text('p_order')+'($current)', style: new TextStyle(
                    color: new Color.fromRGBO(255,255,255, 1.0),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Khmer"
                  ),),
                  onTap: (){
                    _clearCounterm();
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context)=> new CurrentOrderPage(tbl: widget.tbl, ord: widget.ord, item: widget.item, app: widget.app),
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
  void _searchPressed() {
    //_getAllItem();
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: allTranslations.text('label_search'),
          ),
          style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(allTranslations.text('app_title_menu'), style: new TextStyle(fontSize: 16.0,fontFamily: "Khmer"));
        cateall;
        _filter.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String language = allTranslations.currentLanguage;
    return new Scaffold(
      key: _scaffoldKey,
      appBar: _buildBar(context),
      endDrawer: new Drawer(
        child: new ListView.builder(
          itemCount: categorylist == null ? 0 : categorylist.length,
            itemBuilder: (BuildContext context, int index){
              final id = categorylist[index]['CategoryID'];
              var catname;
              if(language == "kh")
              {
                catname = categorylist[index]['CategoryKH'];
              }else{
                catname = categorylist[index]['CategoryName'];
              }
              return new Card(
                child: new ListTile(
                  leading: new CircleAvatar(
                    child: new Text('C'),
                    backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
                  ),
                  title: new Text(catname, style: new TextStyle( fontSize: 12.0),),
                  subtitle: new Text(allTranslations.text('categoryid')+': $id', style: new TextStyle( fontSize: 12.0,fontFamily: "Khmer")),
                  trailing: new Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                     Navigator.of(context).pop();
                    _getCateByID(id);
                  },
                ),
              );
            },
        ),
      ),
      body: _buildList(),
    );
  }
  Widget _buildList() {
    final String language = allTranslations.currentLanguage;
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < cateall.length; i++) {
        if (cateall[i]['description'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(cateall[i]);
        }
      }
      cate = tempList;
    }
    return new GridView.count(
        crossAxisCount: 2,
        padding: new EdgeInsets.all(8.0),
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        children: new List<Widget>.generate(cate == null ? 0 : cate.length, (index) {
          var blob = cate[index]['picture'];
          var image;
          if(blob != "")
          {
            image = new Image.memory(base64.decode(blob), fit: BoxFit.cover,);
          }else{
            image = new Image.asset('images/download.png',fit: BoxFit.cover,);
          } 
          var price = cate[index]['price'];
          var name = cate[index]['description'];
          var namekh = cate[index]['descriptionkh'];
          var itemid = cate[index]['itemid'];
          var qty = 1;
          
          var catname;
          if(language == "kh")
          {
            catname = cate[index]['descriptionkh'];
          }else{
            catname = cate[index]['description'];
          }

          return new GestureDetector(
            child: new Card(
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new ClipRRect(
                      borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                      child: new Stack(
                        children: <Widget>[
                          new AspectRatio(
                            aspectRatio: 17.0 / 12.0,
                            child: new InkWell(
                                child: image,
                                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new DetailPage(image:image,ord:widget.ord,tbl:widget.tbl,price:price,name:name,itemid:itemid,namekh:namekh,app:widget.app),
                                )),
                              ),
                          ),
                          new Positioned(
                            top: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: new Container(
                            decoration: new BoxDecoration(
                              gradient: new LinearGradient(
                                colors: [new Color.fromARGB(200, 0, 0, 0), new Color.fromARGB(0, 0, 0, 0)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )
                            ),
                            padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    '$price '+allTranslations.text('labale_dollar'), 
                                    style: new TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Khmer"
                                    ),
                                  ),
                                ),
                                new Expanded(
                                  child: new RaisedButton(
                                    child: new Text(allTranslations.text('btn_add'), 
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          fontFamily: "Khmer"
                                        )
                                    ),
                                    color: new Color.fromRGBO(183,32,37, 1.0),
                                    elevation: 4.0,
                                    splashColor: Colors.blueGrey,
                                    onPressed: () {
                                      if(cate[index]['modifyID'] == "002")
                                      {
                                        _getExtra(widget.app,cate[index]['itemid'],cate[index]['description'],cate[index]['descriptionkh'],cate[index]['price'],widget.ord,widget.tbl);
                                      }else{
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          child: new AlertDialog(
                                              title: new Center(child: new Text(allTranslations.text('message'), style: new TextStyle(fontSize: 14.0),)),
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
                                                        fontSize: 12.0,
                                                        fontFamily: "Khmer"
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              actions: <Widget>[
                                                new FlatButton(
                                                    child: new Text(allTranslations.text('msg_cancel'),style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer")),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }),
                                                new FlatButton(
                                                    child: new Text(allTranslations.text('msg_ok'),style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer")),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      _saveFromCategory(price,itemid,name,namekh,qty);
                                                    })
                                              ],
                                            ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    //margin: new EdgeInsets.all(5.0),
                    child: new Text(
                      catname,
                      textAlign: TextAlign.center, 
                      style: new TextStyle(
                        fontSize: 12.0,
                        fontFamily: "Khmer",
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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
    }else if(choice == "Summary Order" || choice == "ការបញ្ជាទិញសង្ខេប"){
      Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context)=> new SummaryOrderPage(tbl: widget.tbl,ord: widget.ord,app: widget.app),
      ));
    }else if(choice == "Go To Table" || choice == "ចូលទៅតុ"){
      Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context)=> new TablePage(app:widget.app)
      ));
    }
    else{
      Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
    }
  }
}