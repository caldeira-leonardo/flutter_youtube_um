import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'configs/app_settings.dart';
import 'models/locale.dart';

class AppController {
  static String currencyFormate({
    required BuildContext context,
    required double valor,
  }) {
    CustomLocale loc = context.watch<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: loc.locale, name: loc.name);

    return real.format(valor);
  }
}
