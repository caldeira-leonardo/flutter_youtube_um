import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adapters/conta_hive_adapter.dart';
import 'configs/app_settings.dart';
import 'configs/hide_config.dart';
import 'firebase_options.dart';
import 'meu_aplicativo.dart';
import 'repositories/conta_repository.dart';
import 'repositories/favoritas_repository.dart';
import 'repositories/moeda_repository.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.start();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => MoedaRepository()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(
            create: (context) => FavoritasRepository(
                auth: context.read<AuthService>(),
                moedas: context.read<MoedaRepository>())),
        ChangeNotifierProvider(
            create: (context) => ContaRepository(
                adapter: ContaHiveAdapter(),
                repository: 'posicoes',
                moedas: context.read<MoedaRepository>())),
      ],
      child: const MeuAplicativo(),
    ),
  );
}
