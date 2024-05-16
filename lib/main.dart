import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'configs/app_settings.dart';
import 'meu_aplicativo.dart';
import 'repositories/favoritas_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
      ],
      child: const MeuAplicativo(),
    ),
  );
}
