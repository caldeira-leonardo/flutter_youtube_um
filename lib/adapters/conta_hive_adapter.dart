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
      icone: reader.readString(),
      nome: reader.readString(),
      sigla: reader.readString(),
      preco: reader.readDouble(),
    );
  }

  void writeMoeda(BinaryWriter writer, Moeda obj) {
    writer.writeString(obj.icone);
    writer.writeString(obj.nome);
    writer.writeString(obj.sigla);
    writer.writeDouble(obj.preco);
  }
}
