import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FileName {
  trips,
}

extension FileNameExtension on FileName {
  String get value {
    switch (this) {
      case FileName.trips:
        return 'trips.json';
      default:
        throw ('Invalid file name.');
    }
  }
}

enum StorageType {
  document,
  support,
  temporary,
  preferences,
}

class StorageService {
  static final StorageService _instance = StorageService._internal();

  static Directory? _documents;
  static Directory? _support;
  static Directory? _temporary;
  static SharedPreferences? _preferences;

  StorageService._internal();
  static Future<StorageService> getInstanceAsync() async {
    _documents ??= await getApplicationDocumentsDirectory();
    _support ??= await getApplicationSupportDirectory();
    _temporary ??= await getTemporaryDirectory();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  File? _file({required StorageType storageType, required String fileName}) {
    switch (storageType) {
      case StorageType.document:
        return File('${_documents!.path}/$fileName');

      case StorageType.support:
        return File('${_support!.path}/$fileName');

      case StorageType.temporary:
        return File('${_temporary!.path}/$fileName');

      default:
        throw ('Invalid storage type.');
    }
  }

  Future<T?> getAsync<T>({
    required FileName fileName,
    required T Function(dynamic) fromJson,
    StorageType storageType = StorageType.document,
  }) async {
    switch (storageType) {
      case StorageType.document:
      case StorageType.support:
      case StorageType.temporary:
        final file = _file(
          storageType: storageType,
          fileName: fileName.value,
        );
        if (await file!.exists()) {
          return fromJson(jsonDecode(await file.readAsString()));
        }
        return null;
      case StorageType.preferences:
        final string = _preferences!.getString(fileName.value);
        if (string != null) {
          return fromJson(jsonDecode(string));
        }
        return null;
    }
  }

  Future setAsync({
    StorageType storageType = StorageType.document,
    required FileName fileName,
    required content,
  }) async {
    switch (storageType) {
      case StorageType.document:
      case StorageType.support:
      case StorageType.temporary:
        final file = _file(storageType: storageType, fileName: fileName.value);
        return await file!.writeAsString(jsonEncode(content));
      case StorageType.preferences:
        return await _preferences!
            .setString(fileName.value, jsonEncode(content));
    }
  }

  Future deleteAsync({
    required FileName fileName,
    required StorageType storageType,
  }) async {
    switch (storageType) {
      case StorageType.document:
      case StorageType.support:
      case StorageType.temporary:
        final file = _file(storageType: storageType, fileName: fileName.value);
        return await file!.delete();
      case StorageType.preferences:
        return await _preferences!.remove(fileName.value);
    }
  }
}
