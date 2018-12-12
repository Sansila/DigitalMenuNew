import 'dart:async';
import 'package:appdigitalmenu/database/database_helper.dart';
import 'package:appdigitalmenu/configserver.dart';
import 'package:appdigitalmenu/listtable.dart';
import 'package:appdigitalmenu/translations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
 _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  TextEditingController txtuser = new TextEditingController();
  TextEditingController txtpass = new TextEditingController();
  var type;
  var app;
  List con;
  Future _getConfig() async{
    var db = new DatabaseHelper();
    con = await db.getUser();
    //con.forEach((conf)=>print(conf));
    con.forEach((conf){
      app = conf['appname'];
    });
  }
 
  Future<String> _login() async{
    final response = await http.post("http://$app/DigitalService/dynamicController/login/${txtuser.text}/${txtpass.text}", 
      headers: {
        "Accept": "application/json"
      }
    );
    type = response.body;
    if(type == ""){
      showDialog(
        context: context,
        barrierDismissible: false,
        child: new AlertDialog(
            title: new Center(child: new Text('Message', style: new TextStyle(fontFamily: "Khmer"),)),
            content: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children : <Widget>[
                new Expanded(
                  child: new Text(
                    allTranslations.text('incorrect'),
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
                  child: new Text(allTranslations.text('close'), style: new TextStyle(fontFamily: "Khmer"),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
      );
    }else{
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context)=> new TablePage(type: type, app: app),
      ));
    }
    return "";
  }

  @override
  void initState(){
    _getConfig();
    super.initState();
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onLocaleChanged() async {
      print('Language has been changed to: ${allTranslations.currentLanguage}');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final String language = allTranslations.currentLanguage;
    final String buttonText = language == 'kh' ? 'English' : 'Khmer';

    final logo = new AspectRatio(
      aspectRatio: 10.0 / 5.0,
      //child: new Image.asset('images/boardLogo.png'),
      child: new InkWell(
        child: new Image.asset('images/boardLogo.png'),
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context)=> new ConfigPage(con:con),
          ));
        },
      ),
    );

    final user = new TextFormField(
      controller: txtuser,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: allTranslations.text('enter_user'),
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(32.0),
        ),
      ),
      style: new TextStyle(fontSize: 12.0, color: Colors.black87, fontFamily: "Khmer"),
    );
    final password = new TextFormField(
      controller: txtpass,
      autofocus: false,
      obscureText: true,
      decoration: new InputDecoration(
        hintText: allTranslations.text('enter_pass'),
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(32.0),
        ),
      ),
      style: new TextStyle(fontSize: 12.0,color: Colors.black87, fontFamily: "Khmer"),
    );

    final loginButton = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 15.0),
      child: new Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: new MaterialButton(
          minWidth: screenSize.width,
          //height: MediaQuery.of(context).size.height / 15,
          height: 48.0,
          onPressed: (){
            if(txtpass.text == "" && txtuser.text == "")
            {
              showDialog(
                context: context,
                barrierDismissible: false,
                child: new AlertDialog(
                    title: new Center(child: new Text(allTranslations.text('message'),style: new TextStyle(fontFamily: "Khmer"))),
                    content: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children : <Widget>[
                        new Expanded(
                          child: new Text(
                            allTranslations.text('enter_both'),
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
                          child: new Text(allTranslations.text('close'),style: new TextStyle(fontFamily: "Khmer")),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  
              );
            }else if(txtuser.text == "")
            {
              showDialog(
                context: context,
                barrierDismissible: false,
                child: new AlertDialog(
                    title: new Center(child: new Text(allTranslations.text('message'))),
                    content: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children : <Widget>[
                        new Expanded(
                          child: new Text(
                            allTranslations.text('enter_user'),
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
                          child: new Text(allTranslations.text('close'),style: new TextStyle(fontFamily: "Khmer")),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
              );
            }else if(txtpass.text == "")
            {
              showDialog(
                context: context,
                barrierDismissible: false,
                child: new AlertDialog(
                    title: new Center(child: new Text(allTranslations.text('message'),style: new TextStyle(fontFamily: "Khmer"))),
                    content: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children : <Widget>[
                        new Expanded(
                          child: new Text(
                            allTranslations.text('enter_pass'),
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
                          child: new Text(allTranslations.text('close'),style: new TextStyle(fontFamily: "Khmer")),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
              );
            }else{
              _login();
            }
          },
          color: new Color.fromRGBO(183,32,37, 1.0),
          child: new Text(allTranslations.text('login'), style: new TextStyle(color: Colors.white, fontSize: 12.0,fontFamily: "Khmer")),
        ),
      ),
    );
    final loginGuest = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 0.0),
      child: new Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: new MaterialButton(
          minWidth: screenSize.width,
          //height: MediaQuery.of(context).size.height / 15,
          height: 48.0,
          onPressed: (){
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context)=> new TablePage(type: type,app: app),
            ));
          },
          color: new Color.fromRGBO(183,32,37, 1.0),
          child: new Text(allTranslations.text('guest_login'), style: new TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: "Khmer")),
        ),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(allTranslations.text('app_title_login'),style: new TextStyle(fontSize: 16.0, fontFamily: "Khmer")),
        centerTitle: true,
        backgroundColor: new Color.fromRGBO(183,32,37, 1.0),
      ),
      body: new ListView(
        shrinkWrap: true,
        padding: new EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          new SizedBox(height: 20.0,),
          logo,
          new SizedBox(height: 20.0,),
          user,
          new SizedBox(height: 10.0,),
          password,
          new SizedBox(height: 15.0,),
          loginButton,
          loginGuest,
          new SizedBox(height: 10.0,),
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
                  await allTranslations.setNewLanguage(language == 'kh' ? 'en' : 'kh');
                  setState((){});
                },
                color: new Color.fromRGBO(183,32,37, 1.0),
                child: new Text(buttonText, style: new TextStyle(color: Colors.white, fontSize: 12.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
