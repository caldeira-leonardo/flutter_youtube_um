import 'package:flutter/material.dart';
import 'package:youtube_um/pages/home_page.dart';
import 'package:youtube_um/pages/moedas_page.dart';

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoedasBase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: false),
      home: const HomePage(),
    );
  }
}
