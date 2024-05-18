/* import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'dart:async';

class Mysql {
  static String host = 'localhost',
      user = 'root',
      password = '1234',
      db = 'caritas';

  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async{
    var settings = new ConnectionSettings{
      host: host;
      port: port;
      user: user;
      password: password;
      db: db;
    }
    return await MySqlConnection.connect(settings);
  }
} */
