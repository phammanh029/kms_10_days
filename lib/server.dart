import 'dart:io';

// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:tincan_flutter/Statement.dart';
import 'package:tincan_flutter/Tincan.dart';

class Server {
  HttpServer _server;
  Database _database;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future listen(int port) async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    // final localPath = await _localPath;
    _database =
        await databaseFactoryIo.openDatabase('${await _localPath}/lms.db');
    final tincan = Tincan();
    tincan.initialize({'url': 'https://myworkspace.vn/xapi/thachln/'});
    // var store = intMapStoreFactory.store('tracking');
    // var store = StoreRef.main();
    // open database connection
    _server.listen((request) async {
      print(request.uri.toString());
      // put to android 
      tincan.enqueueStatement(Statement());
      request.response.write('ok');
      await request.response.flush();
      await request.response.close();
    });
  }

  Future close() async {
    _server?.close();
  }
}
