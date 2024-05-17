import '../models/moeda.dart';
import 'hive_repository.dart';

class FavoritasRepository extends HiveRepository<Moeda> {
  FavoritasRepository({required super.adapter, required super.repository});

  saveAll(List<Moeda> moedas) {
    for (var moeda in moedas) {
      if (!lista.any((atual) => atual.sigla == moeda.sigla)) {
        addToList(moeda);
        box.put(moeda.sigla, moeda);
      }
    }
    notifyListeners();
  }

  remove(Moeda moeda) {
    removeFromList(moeda);
    box.delete(moeda.sigla);
    notifyListeners();
  }
}
