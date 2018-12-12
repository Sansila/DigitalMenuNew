import 'dart:async';

import 'package:flutter/material.dart';
import 'package:appdigitalmenu/translations.dart';
import 'package:http/http.dart' as http;
import 'package:appdigitalmenu/database/database_helper.dart';
import 'package:appdigitalmenu/database/model/user.dart';

class ConfigPage extends StatefulWidget {
  final List con;
  ConfigPage({this.con});
  @override
  _ConfigPageState createState() => new _ConfigPageState();
}

class _ConfigData {
  String appname = '';
  String server = '';
  String database = '';
  String user = '';
  String password = '';
  String email;
}

class _ConfigPageState extends State<ConfigPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  var snackBar;
  _ConfigData _data = new _ConfigData();
  bool _validator = false;
  List con; int id; var application; var servername; var databasename; var usernamedb; var passworddb;
  var process;
  var db = new DatabaseHelper();
  
  Future _getAfterUPD() async{
    var db = new DatabaseHelper();
    con = await db.getUser();
    con.forEach((conf){
      id = conf['id'];
      application = conf['appname'];
      servername = conf['server'];
      databasename = conf['database'];
      usernamedb = conf['username'];
      passworddb = conf['password'];
    });
  }

  void submit(id) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      //addRecord(_data.appname,_data.server,_data.database,_data.user,_data.password,id);
      _saveDetail(_data.appname,_data.server,_data.database,_data.user,_data.password,id);
    }else{
      _validator = true;
    }
  }

  Future<String> _saveDetail(appname,server,database,username,password,id) async {
    final response = await http.get("http://$appname/DigitalService/dynamicController?application=$appname&server=$server&database=$database&username=$username&password=$password", 
    headers: {
      "Accept": "application/json"
    });
    if(response.body == "Success")
    {
      addRecord(appname,server,database,username,password,id);
    }else{
      if(id != null)
      {
        User updatedNote = User.fromMap({'id': id, 'appname': '', 'server': '', 'database': '', 'username': '', 'password': ''});
        await db.updateNote(updatedNote);
        snackBar = new SnackBar(
          content: new Text('Your configuration is incorrect.',style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
        _scafoldKey.currentState.showSnackBar(snackBar);
      }
      _getAfterUPD();
      new Timer(const Duration(milliseconds: 400), () {
        setState(() {
          Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
        });
      });
    }
    
    return response.body;
  }

  Future addRecord(appname,server,database,_user,password,id) async {
    if(id == null)
    {
      var user = new User(appname,server,database,_user,password);
      await db.saveUser(user);
      if(await db.saveUser(user) == 1)
      {
        snackBar = new SnackBar(
          content: new Text(allTranslations.text('message_save'),style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
        _scafoldKey.currentState.showSnackBar(snackBar);
        
        new Timer(const Duration(milliseconds: 400), () {
        setState(() {
          Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
        });
      });
        //Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
      }
    }else{
      User updatedNote = User.fromMap({'id': id, 'appname': appname, 'server': server, 'database': database, 'username': _user, 'password': password});
      await db.updateNote(updatedNote);
      if(await db.updateNote(updatedNote) == 1)
      {
        snackBar = new SnackBar(
          content: new Text(allTranslations.text('message_update'),style: new TextStyle(fontFamily: "Khmer"),),
          duration: new Duration(seconds: 3),
        );
        _scafoldKey.currentState.showSnackBar(snackBar);

        new Timer(const Duration(milliseconds: 400), () {
          setState(() {
            Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
          });
        });
        //Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
      }
    }
    _getAfterUPD();
  }

  @override
  void initState() {
    _getAfterUPD();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

@override
  Widget build(BuildContext context) {

    widget.con.forEach((conf){
      id = conf['id'];
      application = conf['appname'];
      servername = conf['server'];
      databasename = conf['database'];
      usernamedb = conf['username'];
      passworddb = conf['password'];
    });

    final Size screenSize = MediaQuery.of(context).size;
      return new Scaffold(
        key: _scafoldKey,
        appBar: new AppBar(
          title: new Text(allTranslations.text('app_title_config'),style: new TextStyle(fontFamily: "Khmer"),),
          centerTitle: true,
          backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil('/LoginPage', (Route<dynamic> route) => false);
            }
          ),
        ),
        body: new Container(
            padding: new EdgeInsets.all(20.0),
            child: new Form(
              autovalidate: _validator,
              key: this._formKey,
              child: new ListView(
                children: <Widget>[
                  new TextFormField(
                    initialValue: application,
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                      hintText: allTranslations.text('enter_app'),
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(32.0),
                      ),
                    ),
                    validator: (String value)
                    {
                      if(value.length == 0)
                      {
                        return allTranslations.text('message_app');
                      }else{
                        return null;
                      }
                    },
                    onSaved: (String value) {
                      _data.appname = value;
                    },
                    style: new TextStyle(fontSize: 12.0, color: Colors.black45,fontFamily: "Khmer"),
                  ),
                  new SizedBox(height: 15.0,),
                  new TextFormField(
                    initialValue: servername,
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                      hintText: allTranslations.text('enter_server'),
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(32.0),
                      ),
                    ),
                    validator: (String value)
                    {
                      if(value.length == 0)
                      {
                        return allTranslations.text('message_server');
                      }else{
                        return null;
                      }
                    },
                    onSaved: (String value) {
                      this._data.server = value;
                    },
                    style: new TextStyle(fontSize: 12.0, color: Colors.black45,fontFamily: "Khmer"),
                  ),
                  new SizedBox(height: 15.0,),
                  new TextFormField(
                    initialValue: databasename,
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                      hintText: allTranslations.text('enter_db'),
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(32.0),
                      ),
                    ),
                    validator: (String value)
                    {
                      if(value.length == 0)
                      {
                        return allTranslations.text('message_database');
                      }else{
                        return null;
                      }
                    },
                    onSaved: (String value) {
                      this._data.database = value;
                    },
                    style: new TextStyle(fontSize: 12.0, color: Colors.black45,fontFamily: "Khmer"),
                  ),
                  new SizedBox(height: 15.0,),
                  new TextFormField(
                    initialValue: usernamedb,
                    keyboardType: TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                      hintText: allTranslations.text('enter_user'),
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(32.0),
                      ),
                    ),
                    validator: (String value)
                    {
                      if(value.length == 0)
                      {
                        return allTranslations.text('message_user');
                      }else{
                        return null;
                      }
                    },
                    onSaved: (String value) {
                      this._data.user = value;
                    },
                    style: new TextStyle(fontSize: 12.0, color: Colors.black45,fontFamily: "Khmer"),
                  ),
                  new SizedBox(height: 15.0,),
                  new TextFormField(
                    initialValue: passworddb,
                    obscureText: true,
                    keyboardType: TextInputType.text,// Use secure text for passwords.
                    decoration: new InputDecoration(
                      hintText: allTranslations.text('enter_dbpwd'),
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(32.0),
                      ),
                    ),
                    validator: (String value)
                    {
                      if(value.length == 0)
                      {
                        return allTranslations.text('message_pwd');
                      }else{
                        return null;
                      }
                    },
                    onSaved: (String value) {
                      this._data.password = value;
                    },
                    style: new TextStyle(fontSize: 12.0, color: Colors.black45,fontFamily: "Khmer"),
                  ),
                  new SizedBox(height: 15.0,),
                  new Padding(
                    padding: new EdgeInsets.symmetric(vertical: 5.0),
                    child: new Material(
                      borderRadius: new BorderRadius.circular(30.0),
                      shadowColor: Colors.lightBlueAccent.shade100,
                      elevation: 5.0,
                      child: new MaterialButton(
                        minWidth: screenSize.width,
                        //height: MediaQuery.of(context).size.height / 15,
                        height: 48.0,
                        onPressed: () async {
                          submit(id);
                        },
                        color: new Color.fromRGBO(183,32,37, 1.0),
                        child: new Text(allTranslations.text('btn_save'), style: new TextStyle(color: Colors.white,fontFamily: "Khmer")),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
      );
  } 
}