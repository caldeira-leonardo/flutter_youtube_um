import 'package:hive/hive.dart';

import '../models/moeda.dart';
import '../models/posicao.dart';

class ContaHiveAdapter extends TypeAdapter<Posicao> {
  @override
  final typeId = 1;

  @override
  Posicao read(BinaryReader reader) {
    return Posicao(quantidade: reader.readDouble(), moeda: readMoeda(reader));
  }

  @override
  void write(BinaryWriter writer, Posicao obj) {
    writer.writeDouble(obj.quantidade);
    writeMoeda(writer, obj.moeda);
  }

  Moeda readMoeda(BinaryReader reader) {
    return Moeda(
      baseId: reader.readString(),
      icone: reader.readString(),
      nome: reader.readString(),
      sigla: reader.readString(),
      preco: reader.readDouble(),
      timestamp: reader.read(),
      mudancaHora: reader.readDouble(),
      mudancaAno: reader.readDouble(),
      mudancaDia: reader.readDouble(),
      mudancaMes: reader.readDouble(),
      mudancaPeriodoTotal: reader.readDouble(),
      mudancaSemana: reader.readDouble(),
    );
  }

  void writeMoeda(BinaryWriter writer, Moeda obj) {
    writer.writeString(obj.baseId);
    writer.writeString(obj.icone);
    writer.writeString(obj.nome);
    writer.writeString(obj.sigla);
    writer.writeDouble(obj.preco);
    writer.write(obj.timestamp);
    writer.writeDouble(obj.mudancaHora);
    writer.writeDouble(obj.mudancaAno);
    writer.writeDouble(obj.mudancaDia);
    writer.writeDouble(obj.mudancaMes);
    writer.writeDouble(obj.mudancaPeriodoTotal);
    writer.writeDouble(obj.mudancaSemana);
  }
}
