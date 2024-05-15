import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:youtube_um/models/moeda.dart';
import 'package:youtube_um/pages/moedas_detalhes_page.dart';
import 'package:youtube_um/repositories/moeda_repository.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> with TickerProviderStateMixin {
  bool showFAB = true;

  late final _controller = AnimationController(
      duration: const Duration(microseconds: 400), vsync: this)
    ..forward();

  late final _animation =
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

  @override
  void dispose() {
    dispose();
    _controller.dispose();
    _animation.dispose();
  }

  var tabela = MoedaRepository.tabela;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Moeda> selecionadas = [];
  bool isSorted = false;

  sortItems() {
    if (!isSorted) {
      tabela.sort(
        (a, b) => a.nome.compareTo(b.nome),
      );
    } else {
      tabela = tabela.reversed.toList();
    }
    isSorted = !isSorted;
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: const Text('Cripto Moedas'),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black87),
      );
    }
  }

  handleShowFavoriteButton() {
    return selecionadas.isNotEmpty
        ? ScaleTransition(
            scale: _animation,
            child: FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.star),
              label: const Text(
                'FAVORITAR',
                style: TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : null;
  }

  mostrarDetalhes(moeda) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => MoedasDetalhesPage(moeda: moeda)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, __) => [
            const SliverAppBar(
              title: Text('Cripto moedas'),
              snap: true,
              floating: true,
            )
          ],
          body: NotificationListener<UserScrollNotification>(
            onNotification: (scroll) {
              if (scroll.direction == ScrollDirection.reverse && showFAB) {
                _controller.reverse();
                showFAB = false;
              } else if (scroll.direction == ScrollDirection.forward &&
                  !showFAB) {
                _controller.forward();
                showFAB = true;
              }
              return true;
            },
            child: ListView.separated(
                itemBuilder: (BuildContext context, int moeda) {
                  return ListTile(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    leading: (selecionadas.contains(tabela[moeda]))
                        ? const CircleAvatar(
                            child: Icon(Icons.check),
                          )
                        : SizedBox(
                            width: 40,
                            child: Image.asset(tabela[moeda].icone),
                          ),
                    title: Text(tabela[moeda].nome,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500)),
                    trailing: Text(real.format(tabela[moeda].preco)),
                    selected: selecionadas.contains(tabela[moeda]),
                    selectedTileColor: Colors.indigo[50],
                    onTap: () => mostrarDetalhes(tabela[moeda]),
                    onLongPress: () {
                      setState(() {
                        (selecionadas.contains(tabela[moeda]))
                            ? selecionadas.remove(tabela[moeda])
                            : selecionadas.add(tabela[moeda]);
                      });
                    },
                  );
                },
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const Divider(),
                itemCount: tabela.length),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: handleShowFavoriteButton());
  }
}
