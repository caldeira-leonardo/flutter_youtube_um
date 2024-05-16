import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../app_controller.dart';
import '../configs/app_settings.dart';
import '../models/moeda.dart';
import '../repositories/favoritas_repository.dart';
import '../repositories/moeda_repository.dart';
import 'moedas_detalhes_page.dart';

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

  var tabela = MoedaRepository.tabela;

  late FavoritasRepository favoritas;

  List<Moeda> selecionadas = [];
  bool isSorted = false;

  changeLanguageButton() {
    AppSettings appSettings = context.watch<AppSettings>();
    final loc = appSettings.locale;

    final locale = loc.locale == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc.locale == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_vert),
            title: Text('Usar $locale'),
            onTap: () {
              context.read<AppSettings>().setLocale(locale, name);
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

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
    return selecionadas.isEmpty
        ? SliverAppBar(
            title: const Text('Cripto Moedas'),
            actions: [changeLanguageButton()],
          )
        : SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: limparSelecionadas,
            ),
            title: Text('${selecionadas.length} selecionadas'),
            backgroundColor: Colors.blueGrey[50],
            elevation: 1,
            titleTextStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            iconTheme: const IconThemeData(color: Colors.black87),
          );
  }

  handleShowFavoriteButton() {
    return selecionadas.isNotEmpty
        ? ScaleTransition(
            scale: _animation,
            child: FloatingActionButton.extended(
              onPressed: () {
                favoritas.saveAll(selecionadas);
                limparSelecionadas();
              },
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

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  handleSelectMoeda(moeda) {
    setState(() {
      (selecionadas.contains(tabela[moeda]))
          ? selecionadas.remove(tabela[moeda])
          : selecionadas.add(tabela[moeda]);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // favoritas = Provider.of<FavoritasRepository>(context);
    favoritas = context.watch<FavoritasRepository>();

    return Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, __) => [appBarDinamica()],
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
                    title: Row(
                      children: [
                        Text(tabela[moeda].nome,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500)),
                        if (favoritas.lista
                            .any((fav) => fav.sigla == tabela[moeda].sigla))
                          const Icon(Icons.circle, color: Colors.amber, size: 8)
                      ],
                    ),
                    trailing: Text(
                      AppController.currencyFormate(
                        context: context,
                        valor: tabela[moeda].preco,
                      ),
                    ),
                    selected: selecionadas.contains(tabela[moeda]),
                    selectedTileColor: Colors.indigo[50],
                    onTap: () => handleSelectMoeda(moeda),
                    onLongPress: () => handleSelectMoeda(moeda),
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
