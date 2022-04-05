import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum FileName { trips }

extension FileNameExtension on FileName {
  String get value {
    switch (this) {
      case FileName.trips:
        return 'trips.json';
      default:
        throw ('File name not found.');
    }
  }
}

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  static Directory? _directory;

  LocalStorage._internal();
  static Future<LocalStorage> init() async {
    _directory ??= await getApplicationDocumentsDirectory();
    return _instance;
  }

  File _localFile({required String fileName}) {
    final path = _directory?.path;
    return File('$path/$fileName');
  }

  Future<T?> readFile<T>({required FileName fileName}) async {
    try {
      final file = _localFile(fileName: fileName.value);
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return null;
    }
  }

  Future<File> writeFile(
      {required FileName fileName, required dynamic content}) async {
    final file = _localFile(fileName: fileName.value);
    return file.writeAsString(jsonEncode(content));
  }
}
