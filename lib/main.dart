import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_um/meu_aplicativo.dart';
import 'package:youtube_um/repositories/favoritas_repository.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritasRepository(),
      child: const MeuAplicativo(),
    ),
  );
}
