import '../models/moeda.dart';
import '../models/posicao.dart';
import 'hive_repository.dart';
import 'moeda_repository.dart';

class ContaRepository extends HiveRepository<Posicao> {
  List<Posicao> _carteira = [];
  double _saldo = 0;
  final moedas = MoedaRepository.tabela;

  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;

  ContaRepository({
    required super.adapter,
    required super.repository,
  });

  _getSaldo() async {
    double conta = await box.get('saldo');
    _saldo = conta;
    notifyListeners();
  }

  setSaldo(double valor) async {
    await box.put('saldo', valor);
    _saldo = valor;
    notifyListeners();
  }

  // comprar(Moeda moeda, double valor) async {
  //   db = await DB.instance.database;
  //   await db.transaction((txn) async {
  //     // Verificar se a moeda já foi comprada
  //     final posicaoMoeda = await txn.query(
  //       'carteira',
  //       where: 'sigla = ?',
  //       whereArgs: [moeda.sigla],
  //     );
  //     // Se não tem a moeda em carteira
  //     if (posicaoMoeda.isEmpty) {
  //       await txn.insert('carteira', {
  //         'sigla': moeda.sigla,
  //         'moeda': moeda.nome,
  //         'quantidade': (valor / moeda.preco).toString()
  //       });
  //     }
  //     // Já tem a moeda em carteira
  //     else {
  //       final atual = double.parse(posicaoMoeda.first['quantidade'].toString());
  //       await txn.update(
  //         'carteira',
  //         {'quantidade': (atual + (valor / moeda.preco)).toString()},
  //         where: 'sigla = ?',
  //         whereArgs: [moeda.sigla],
  //       );
  //     }

  //     // Inserir a compra no historico
  //     await txn.insert('historico', {
  //       'sigla': moeda.sigla,
  //       'moeda': moeda.nome,
  //       'quantidade': (valor / moeda.preco).toString(),
  //       'valor': valor,
  //       'tipo_operacao': 'compra',
  //       'data_operacao': DateTime.now().millisecondsSinceEpoch
  //     });

  //     //Atualizar o saldo
  //     await txn.update('conta', {'saldo': saldo - valor});
  //   });
  //   await _initRepository();
  //   notifyListeners();
  // }

  _getCarteira() async {
    _carteira = [];
    List posicoes = await box.get('carteira');
    for (var posicao in posicoes) {
      Moeda moeda = moedas.firstWhere(
        (m) => m.sigla == posicao['sigla'],
      );
      _carteira.add(Posicao(
        moeda: moeda,
        quantidade: double.parse(posicao['quantidade']),
      ));
    }
    notifyListeners();
  }
}
