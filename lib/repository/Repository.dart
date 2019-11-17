import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Repository {
  static const DATA_NAME = 'data';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<bool> hasOfflineData() async {
    final path = await _localPath;
    return File('$path/$DATA_NAME.zip').exists();
  }

  Future downloadFile(String url) async {
    final dio = Dio();
    final path = await _localPath;
    dio.interceptors.add(LogInterceptor());
    await _download(dio, url, '$path/$DATA_NAME.zip');
  }

  Future _download(Dio dio, String url, savePath) async {
    CancelToken cancelToken = CancelToken();
    try {
      await dio.download(url, savePath, cancelToken: cancelToken);
    } catch (e) {
      print(e);
    }
  }

  Future removeData() async {
    final path = await _localPath;
    final dir = Directory('$path/$DATA_NAME');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future extractOffline() async {
    final path = await _localPath;
    List<int> bytes = File('$path/$DATA_NAME.zip').readAsBytesSync();

    // Decode the Zip file
    Archive archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (ArchiveFile file in archive) {
      String filename = file.name;
      if (file.isFile) {
        List<int> data = file.content;
        File('$path/$DATA_NAME/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$path/$DATA_NAME/$filename')..create(recursive: true);
      }
    }

    // replace content of index.html file
    final file = File('$path/$DATA_NAME/index.html');
    final content = await file.readAsString();
    await file.writeAsString(content.replaceAll(
        'endPoint: "https://myworkspace.vn/xapi/thachln/"',
        //endPoint:\s*"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)"
        'endPoint: "http://${InternetAddress.loopbackIPv4.host}:9000/"'));
        // 'endPoint: `http://localhost:9000/?host=\${((url)=> {let rs = /host=([^&]*)/.exec(url);  return rs && rs[1];})("https://myworkspace.vn/xapi/thachln/")||"https://myworkspace.vn/xapi/thachln/"}`'));
  }

  Future<String> loadOfflineContent() async {
    final path = await _localPath;
    final dir = Directory('$path/$DATA_NAME');
    if (!await dir.exists()) {
      throw Exception('dir not exist');
    }

    final content = await File('$path/$DATA_NAME/index.html').readAsString();
    // get file index
    return File('$path/$DATA_NAME/index.html').path;
  }
}
