import 'dart:async';
import 'dart:convert';
import 'package:appdigitalmenu/category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListCategoryPage extends StatefulWidget {
  final String tbl; final int ord;
  ListCategoryPage({this.tbl,this.ord});
  @override
  _ListCategoryPageState createState() => new _ListCategoryPageState(tbl:tbl,ord:ord);
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  final String tbl; final int ord;
  _ListCategoryPageState({this.tbl,this.ord});

  List categorylist;

  Future<String> _getCateList() async{
      http.Response response = await http.get(
        Uri.encodeFull("http://192.168.0.110:81/DigitalService/dynamicController/left_menu"),
        headers: {
          "Accept": "application/json"
        }
      );
      this.setState((){
        categorylist = json.decode(response.body);
      });
      return "successfully";
  }

  @override
  void initState() {
    _getCateList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('List Category',style: new TextStyle(fontSize: 16.0)),
        centerTitle: true,
        backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
      ),
      body: new ListView.builder(
        itemCount: categorylist == null ? 0 : categorylist.length,
        itemBuilder: (BuildContext context, int index){
          final id = categorylist[index]['CategoryID'];
          return new Card(
            child: new ListTile(
              leading: new CircleAvatar(
                child: new Text('C'),
              ),
              title: new Text(categorylist[index]['CategoryName'], style: new TextStyle( fontSize: 20.0),),
              subtitle: new Text('CategoryId: $id'),
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new CategoryPage(tbl:tbl, ord:ord,item:id),
                  ),
                );
              },
              trailing: new Icon(Icons.keyboard_arrow_right),
            ),
          );
        },
      ),
    );
  }
}