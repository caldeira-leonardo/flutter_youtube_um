import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../adapters/conta_hive_adapter.dart';
import '../models/posicao.dart';

class ContaRepository extends ChangeNotifier {
  final List<Posicao> _posicoes = [];
  late LazyBox box;

  ContaRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readPosicoes();
  }

  _openBox() async {
    Hive.registerAdapter(ContaHiveAdapter());
    box = await Hive.openLazyBox<Posicao>('posicoes');
  }

  _readPosicoes() async {
    for (var posicao in box.keys) {
      Posicao p = await box.get(posicao);
      _posicoes.add(p);
      notifyListeners();
    }
  }
}
