import 'package:flutter/material.dart';

class FavoritasPage extends StatefulWidget {
  const FavoritasPage({super.key});

  @override
  FavoritasPageState createState() => FavoritasPageState();
}

class FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moedas favoritas'),
      ),
    );
  }
}
