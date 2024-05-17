import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adapters/moeda_hive_adapter.dart';
import 'configs/app_settings.dart';
import 'configs/hide_config.dart';
import 'meu_aplicativo.dart';
import 'repositories/favoritas_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(
            create: (context) => FavoritasRepository(
                adapter: MoedaHiveAdapter(), repository: 'moedas_favoritas')),
      ],
      child: const MeuAplicativo(),
    ),
  );
}
