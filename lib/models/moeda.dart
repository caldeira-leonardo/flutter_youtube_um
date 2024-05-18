import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Moeda {
  String baseId;
  String icone;
  String nome;
  String sigla;
  double preco;
  DateTime timestamp;
  double mudancaHora;
  double mudancaDia;
  double mudancaSemana;
  double mudancaMes;
  double mudancaAno;
  double mudancaPeriodoTotal;

  Moeda({
    required this.baseId,
    required this.icone,
    required this.nome,
    required this.sigla,
    required this.preco,
    required this.timestamp,
    required this.mudancaHora,
    required this.mudancaDia,
    required this.mudancaSemana,
    required this.mudancaMes,
    required this.mudancaAno,
    required this.mudancaPeriodoTotal,
  });

  removeNull(value, defaultValue) {
    value == 'null' ? defaultValue : value;
  }

  factory Moeda.fromJson(Map<String, dynamic> json) {
    log('${json['icone']}', name: 'ICONE');

    return Moeda(
      sigla: json['sigla'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      baseId: json['baseId'],
      preco: double.parse(json['preco']),
      mudancaSemana: double.parse(
          json['mudancaSemana'] == 'null' ? '0' : json['mudancaSemana']),
      mudancaPeriodoTotal: double.parse(json['mudancaPeriodoTotal'] == 'null'
          ? '0'
          : json['mudancaPeriodoTotal']),
      mudancaMes:
          double.parse(json['mudancaMes'] == 'null' ? '0' : json['mudancaMes']),
      mudancaAno:
          double.parse(json['mudancaAno'] == 'null' ? '0' : json['mudancaAno']),
      mudancaDia:
          double.parse(json['mudancaDia'] == 'null' ? '0' : json['mudancaDia']),
      mudancaHora: double.parse(
          json['mudancaHora'] == 'null' ? '0' : json['mudancaHora']),
      nome: json['nome'],
      icone: '${json['icone']}' ??
          'https://cdn.pixabay.com/photo/2017/02/12/21/29/false-2061132_640.png',
    );
  }
}
