import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveRepository<T> extends ChangeNotifier {
  final List<T> _lista = [];
  late LazyBox box;

  HiveRepository(
      {required TypeAdapter<T> adapter, required String repository}) {
    _startRepository(adapter: adapter, repository: repository);
  }

  _openBox(TypeAdapter<T> adapter, String repository) async {
    Hive.registerAdapter(adapter);
    box = await Hive.openLazyBox<T>(repository);
  }

  _readData() async {
    for (var data in box.keys) {
      T d = await box.get(data);
      _lista.add(d);
      notifyListeners();
    }
  }

  _startRepository({required adapter, required repository}) async {
    await _openBox(adapter, repository);
    await _readData();
  }

  addToList(data) {
    _lista.add(data);
  }

  removeFromList(data) {
    _lista.remove(data);
  }

  UnmodifiableListView<T> get lista => UnmodifiableListView(_lista);
}
