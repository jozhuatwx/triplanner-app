import 'package:flutter/material.dart';
import 'package:triplanner/services/storage.service.dart';

class ProviderBase<T> extends ChangeNotifier {
  late final FileName _fileName;
  late Duration _expirationTime;
  late StorageType _storageType;
  T? _data;
  T? _backupData;
  DateTime? _lastGetLatest;
  late final T defaultValue;

  ProviderBase({
    required FileName fileName,
    required this.defaultValue,
    Duration expirationTime = const Duration(minutes: 30),
    StorageType storageType = StorageType.document,
  }) {
    _fileName = fileName;
    _expirationTime = expirationTime;
    _storageType = storageType;
    _data = defaultValue;
  }

  @protected
  T? get getData {
    return _data;
  }

  @protected
  Future<T?> getDataAsync({
    required T Function(dynamic) fromJson,
    bool notify = true,
  }) async {
    if (_lastGetLatest == null ||
        _lastGetLatest!.isBefore(_lastGetLatest!.add(_expirationTime))) {
      return await getLatestDataAsync(fromJson: fromJson, notify: notify);
    }
    return _data;
  }

  @protected
  Future<T?> getLatestDataAsync({
    required T Function(dynamic) fromJson,
    bool notify = true,
  }) async {
    var storage = await StorageService.getInstanceAsync();
    var data = await storage.getAsync<T>(
          fromJson: fromJson,
          storageType: _storageType,
          fileName: _fileName,
        ) ??
        defaultValue;
    _lastGetLatest = DateTime.now();

    if (data != _data) {
      _data = data;
      if (notify) notifyListeners();
    }
    return _data;
  }

  @protected
  Future<T?> setDataAsync({
    required T? content,
    bool notify = true,
  }) async {
    return _rollbackableAsync(funcAsync: () async {
      _data = content;

      if (notify) notifyListeners();

      var storage = await StorageService.getInstanceAsync();
      await storage.setAsync(
          storageType: _storageType, fileName: _fileName, content: content);

      return _data;
    });
  }

  @protected
  Future deleteDataAsync({
    bool notify = true,
  }) async {
    await setDataAsync(content: null, notify: notify);
  }

  Future<T?> _rollbackableAsync({
    required Future<T?> Function() funcAsync,
    bool notify = true,
  }) async {
    _backupData = _data;

    return await Future.sync(funcAsync).catchError((e) {
      _data = _backupData;

      if (notify) notifyListeners();
      return _data;
    });
  }
}

class ProviderListBase<T extends List> extends ProviderBase<T> {
  ProviderListBase({
    required FileName fileName,
    required T defaultValue,
    Duration expirationTime = const Duration(minutes: 30),
    StorageType storageType = StorageType.document,
  }) : super(
          fileName: fileName,
          expirationTime: expirationTime,
          storageType: storageType,
          defaultValue: defaultValue,
        );

  @protected
  Future<T?> insertDataAsync({
    required content,
    bool notify = true,
    int? index,
  }) async {
    return await _rollbackableAsync(funcAsync: () async {
      if (index != null && (index! < 0 || index! >= (_data as List).length)) {
        throw ('Index is invalid');
      } else {
        index = (_data as List).length - 1;
      }

      if (content is List) {
        _data!.insertAll(index!, content);
      } else {
        _data!.insert(index!, content);
      }

      if (notify) notifyListeners();
      return _data;
    });
  }

  @protected
  Future<T?> updateDataListAsync({
    required content,
    required int index,
    bool notify = true,
    bool insert = false,
  }) async {
    return await _rollbackableAsync(funcAsync: () async {
      if (index < 0 || index >= (_data as List).length) {
        if (insert) {
          _data!.add(content);
        } else {
          throw ('Index is invalid.');
        }
      } else {
        _data![index] = content;
      }

      if (notify) notifyListeners();

      var storage = await StorageService.getInstanceAsync();
      await storage.setAsync(
          storageType: _storageType, fileName: _fileName, content: _data);

      return _data;
    });
  }

  @protected
  Future<T?> removeDataAsync({
    required element,
    bool notify = true,
  }) async {
    return await _rollbackableAsync(funcAsync: () async {
      (_data as List).remove(element);

      if (notify) notifyListeners();
      return _data;
    });
  }

  @protected
  Future<T?> removeDataAtAsync({
    required int index,
    bool notify = true,
    int? toIndex,
  }) async {
    return await _rollbackableAsync(funcAsync: () async {
      if (toIndex != null) {
        _data!.removeRange(index, toIndex);
      } else {
        _data!.removeAt(index);
      }

      if (notify) notifyListeners();
      return _data;
    });
  }
}
