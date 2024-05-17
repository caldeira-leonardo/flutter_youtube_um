import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig<T> {
  static start() async {
    await Hive.initFlutter();
  }
}
