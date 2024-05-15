import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youtube_um/models/moeda.dart';
import 'package:youtube_um/repositories/moeda_repository.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
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
        ? FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.star),
            label: const Text(
              'FAVORITAR',
              style: TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
            ),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarDinamica(),
          actions: [
            IconButton(
                onPressed: () => setState(() {
                      sortItems();
                    }),
                icon: const Icon(Icons.swap_vert_circle))
          ],
        ),
        body: ListView.separated(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: handleShowFavoriteButton());
  }
}
