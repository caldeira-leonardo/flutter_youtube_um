import 'package:flutter/material.dart';

import 'comidas_page.dart';
import 'configuracoes_page.dart';
import 'favoritas_page.dart';
import 'firebase_page.dart';
import 'flexible_page.dart';
import 'moedas_page.dart';

enum BottomNavBar { novo, antigo }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;
  static const selectedPage = BottomNavBar.antigo;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  handleSelectPages(Enum type) {
    return type == BottomNavBar.antigo
        ? [
            const MoedasPage(),
            const FavoritasPage(),
            const ConfiguracoesPage(),
          ]
        : [
            const FlexiblePage(),
            const RestauranteDetalhes(),
            const FirebaseApp(),
          ];
  }

  handleSelectNagivation(Enum type) {
    const double iconSize = 30;

    return (type == BottomNavBar.antigo)
        ? BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: paginaAtual,
            onTap: (pagina) {
              pc.animateToPage(pagina,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.ease);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todas'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star), label: 'Favoritas'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Conta'),
            ],
          )
        : NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.lightBlue.withOpacity(0.1),
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            child: NavigationBar(
              selectedIndex: paginaAtual,
              onDestinationSelected: (int i) => pc.animateToPage(i,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.ease),
              destinations: const [
                NavigationDestination(
                    selectedIcon: Icon(
                      Icons.list,
                      size: iconSize,
                    ),
                    icon: Icon(
                      Icons.list,
                      size: iconSize,
                    ),
                    label: 'Todas'),
                NavigationDestination(
                    selectedIcon: Icon(
                      Icons.fastfood,
                      size: iconSize,
                    ),
                    icon: Icon(
                      Icons.fastfood_outlined,
                      size: iconSize,
                    ),
                    label: 'Comidas'),
                NavigationDestination(
                    selectedIcon: Icon(
                      Icons.chat,
                      size: iconSize,
                    ),
                    icon: Icon(
                      Icons.chat_outlined,
                      size: iconSize,
                    ),
                    label: 'Firebase'),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setPaginaAtual,
        children: handleSelectPages(selectedPage),
      ),
      bottomNavigationBar: handleSelectNagivation(selectedPage),
    );
  }
}
