import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enums/directory_name.dart';

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
    if (_documents == null) {
      _documents = await getApplicationDocumentsDirectory();
      _support = await getApplicationSupportDirectory();
      _temporary = await getTemporaryDirectory();
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  File _file({
    required Directory directory,
    required String fileName,
  }) {
    return File("${directory.path}/$fileName");
  }

  Directory _directory({
    required StorageType storageType,
    required DirectoryName directoryName,
  }) {
    switch (storageType) {
      case StorageType.document:
        return Directory('${_documents!.path}/${directoryName.value}');

      case StorageType.support:
        return Directory('${_support!.path}/${directoryName.value}');

      case StorageType.temporary:
        return Directory('${_temporary!.path}/${directoryName.value}');

      default:
        throw ('Invalid storage type.');
    }
  }

  Future<T?> getAsync<T>({
    required DirectoryName directoryName,
    required String fileName,
    required T Function(dynamic) fromJson,
    StorageType storageType = StorageType.document,
  }) async {
    switch (storageType) {
      case StorageType.document:
      case StorageType.support:
      case StorageType.temporary:
        final directory = _directory(
          storageType: storageType,
          directoryName: directoryName,
        );

        if (await directory.exists()) {
          final file = _file(
            directory: directory,
            fileName: fileName,
          );

          if (await file.exists()) {
            return fromJson(jsonDecode(await file.readAsString()));
          }
        }
        return null;
      case StorageType.preferences:
        final string =
            _preferences!.getString('${directoryName.value}/$fileName');
        if (string != null) {
          return fromJson(jsonDecode(string));
        }
        return null;
    }
  }

  Future setAsync({
    StorageType storageType = StorageType.document,
    required DirectoryName directoryName,
    required String fileName,
    required content,
  }) async {
    switch (storageType) {
      case StorageType.document:
      case StorageType.support:
      case StorageType.temporary:
        final directory = _directory(
          storageType: storageType,
          directoryName: directoryName,
        );
        if (!await directory.exists()) {
          await directory.create();
        }

        final file = _file(
          directory: directory,
          fileName: fileName,
        );
        return await file.writeAsString(jsonEncode(content));
      case StorageType.preferences:
        return await _preferences!
            .setString('${directoryName.value}/$fileName', jsonEncode(content));
    }
  }

  Future<bool> deleteAsync({
    required DirectoryName directoryName,
    required String fileName,
    required StorageType storageType,
  }) async {
    switch (storageType) {
      case StorageType.document:
      case StorageType.support:
      case StorageType.temporary:
        final directory = _directory(
          storageType: storageType,
          directoryName: directoryName,
        );

        if (await directory.exists()) {
          final file = _file(
            directory: directory,
            fileName: fileName,
          );

          try {
            await file.delete();
            return true;
          } catch (e) {
            return false;
          }
        }
        return true;
      case StorageType.preferences:
        return await _preferences!.remove('${directoryName.value}/$fileName');
    }
  }
}
