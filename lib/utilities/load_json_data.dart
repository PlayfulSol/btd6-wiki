import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map?> loadJsonData(Uri path) async {
  final response = await http.get(path);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return null;
  }
}

List<String> getFilesInFolder(String path) {
  final List<String> files = [];
  final Directory directory = Directory(path);
  final List<FileSystemEntity> entities = directory.listSync();
  for (FileSystemEntity entity in entities) {
    if (entity is File && entity.path.endsWith('.json')) {
      files.add(entity.path);
    }
  }
  return files;
}
