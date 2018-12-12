class User {

  int id;
  String _appname;
  String _server;
  String _database;
  String _user;
  String _pwd;

  User(this._appname, this._server, this._database, this._user, this._pwd);

  User.map(dynamic obj) {
    this._appname = obj["appname"];
    this._server = obj["server"];
    this._database = obj["database"];
    this._user = obj["username"];
    this._pwd = obj["password"];    
  }

  String get appname  => _appname;
  String get server   => _server;
  String get database => _database;
  String get username => _user;
  String get password => _pwd;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["appname"] = _appname;
    map["server"] = _server;
    map["database"] = _database;
    map["username"] = _user;
    map["password"] = _pwd;
    return map;
  }
  void setUserId(int id) {
    this.id = id;
  }
  User.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this._appname = map["appname"];
    this._server = map["server"];
    this._database = map["database"];
    this._user = map["username"];
    this._pwd = map["password"]; 
  }
}