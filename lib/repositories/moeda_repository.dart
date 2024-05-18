import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../databases/db_firestore.dart';
import '../models/moeda.dart';
import '../services/auth_service.dart';

class MoedaRepository extends ChangeNotifier {
  List<Moeda> _tabela = [];
  late AuthService auth;
  late FirebaseFirestore db;

  List<Moeda> get tabela => _tabela;

  MoedaRepository() {
    _startFirestore();
    _readMoedas();
    _setupDadosTableMoeda();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _moedasTableIsEmpty() async {
    final snapshot = await db.collection('moedas').get();

    log(snapshot.docs.isEmpty.toString(), name: 'snapshot.docs.isEmpty');

    return snapshot.docs.isEmpty ? true : false;
  }

  _readMoedas() async {
    final snapshot = await db.collection('moedas').get();

    snapshot.docs.forEach((doc) {
      Map<String, dynamic> firebaseMoeda = doc.data();

      Moeda moeda = Moeda.fromJson(firebaseMoeda);
      // Moeda moeda =
      //     moedas.tabela.firstWhere((moeda) => moeda.sigla == doc.get('sigla'));
      _tabela.add(moeda);
      notifyListeners();
    });
  }

  _setupDadosTableMoeda() async {
    if (await _moedasTableIsEmpty()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> moedas = json['data'];

        moedas.forEach((moeda) async {
          final preco = moeda['latest_price'];
          final timestamp = DateTime.parse(preco['timestamp']);

          log(moeda['image_url'], name: 'URL MOEDA');

          await db.collection('moedas').doc(moeda['name']).set({
            'baseId': moeda['id'],
            'sigla': moeda['symbol'],
            'nome': moeda['name'],
            'icone': moeda['image_url'].toString(),
            'preco': moeda['latest'],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'mudancaHora': preco['percent_change']['hour'].toString(),
            'mudancaDia': preco['percent_change']['day'].toString(),
            'mudancaSemana': preco['percent_change']['week'].toString(),
            'mudancaMes': preco['percent_change']['month'].toString(),
            'mudancaAno': preco['percent_change']['year'].toString(),
            'mudancaPeriodoTotal': preco['percent_change']['all'].toString()
          });
        });
      }

      _readMoedas();
    }
  }
}
