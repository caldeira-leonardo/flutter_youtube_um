import 'package:flutter/material.dart';
import 'package:youtube_um/models/comida.dart';
import 'package:youtube_um/repositories/comida_repository.dart';

class RestauranteDetalhes extends StatefulWidget {
  const RestauranteDetalhes({super.key});

  @override
  State<RestauranteDetalhes> createState() => _RestauranteDetalhesState();
}

class _RestauranteDetalhesState extends State<RestauranteDetalhes> {
  final List<GlobalKey> categorias = [GlobalKey(), GlobalKey(), GlobalKey()];
  late ScrollController scrollCont;
  BuildContext? tabContext;

  @override
  void initState() {
    scrollCont = ScrollController();
    scrollCont.addListener(changeTabs);
    super.initState();
  }

  changeTabs() {
    late RenderBox box;

    for (var i = 0; i < categorias.length; i++) {
      box = categorias[i].currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);

      if (scrollCont.offset >= position.dy) {
        DefaultTabController.of(tabContext!).animateTo(
          i,
          duration: const Duration(milliseconds: 100),
        );
      }
    }
  }

  scrollTo(int index) async {
    scrollCont.removeListener(changeTabs);
    final categoria = categorias[index].currentContext!;
    await Scrollable.ensureVisible(
      categoria,
      duration: const Duration(milliseconds: 600),
    );
    scrollCont.addListener(changeTabs);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          tabContext = context;
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.red),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.red,
                  ),
                )
              ],
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'BURGÃO',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Entrega em 40-50 min',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  )
                ],
              ),
              bottom: TabBar(
                tabs: const [
                  Tab(child: Text('Carnes')),
                  Tab(child: Text('Burgers')),
                  Tab(child: Text('Combos')),
                ],
                onTap: (int index) => scrollTo(index),
              ),
            ),
            body: SingleChildScrollView(
              controller: scrollCont,
              child: Column(
                children: [
                  categoriaComida('Carnes', 0),
                  gerarListaComidas(ComidaRepository.carnes),
                  categoriaComida('Burgers', 1),
                  gerarListaComidas(ComidaRepository.burgers),
                  categoriaComida('Combos', 2),
                  gerarListaComidas(ComidaRepository.combos),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  gerarListaComidas(List<Comida> comidas) {
    return Column(
      children: comidas.map((comida) => comidaItem(comida)).toList(),
    );
  }

  Widget comidaItem(Comida comida) {
    return Column(
      children: [
        ListTile(
          title: Text(comida.nome),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comida.descricao,
                  style: const TextStyle(fontSize: 13),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    comida.preco,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          trailing: Image.network(comida.imagem),
          contentPadding: const EdgeInsets.all(15),
        ),
        const Divider(),
      ],
    );
  }

  Widget categoriaComida(String titulo, int index) {
    return Padding(
      key: categorias[index],
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          ListTile(
            title: Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
