import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/core/models/language.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../utils/preferences.dart';

class UIProvider extends ChangeNotifier {
  SnappingSheetController sheetController = SnappingSheetController();
  Locale? selectedLocale;

  List<Language>? languages = [];
  List<Locale>? locales = [
    Locale("en", "US"),
    Locale("in", "ID"),
  ];

  void setLanguage(BuildContext context, Locale locale) {
    EasyLocalization.of(context)!.setLocale(locale);
    selectedLocale = locale;
    Preferences.init().then((value) {
      value.saveLocale(locale);
    });
    notifyListeners();
  }

  static void initializeLanguages(BuildContext context) async {
    var load = await DefaultAssetBundle.of(context).loadString("assets/languages/env.json");
    UIProvider provider = UIProvider.instance(context);
    provider.languages = (jsonDecode(load)).map((e) => Language.fromJson(e)).toList().cast<Language>();
    provider.locales = provider.languages!.map((e) => Locale(e.languageCode!, e.countryCode)).toList();

    Preferences.init().then((value) {
      if (value.locale != null) provider.setLanguage(context, value.locale!);
    });
    provider.notifyListeners();
  }

  static UIProvider instance(BuildContext context) => Provider.of(context, listen: false);
}
