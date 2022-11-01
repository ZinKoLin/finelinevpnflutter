import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nizvpn/core/provider/uiProvider.dart';
import 'package:provider/provider.dart';

import '../../core/provider/adsProvider.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  void initState() {
    UIProvider.initializeLanguages(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("setting_language".tr()),
        leading: IconButton(
          icon: Icon(LineIcons.angleLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<UIProvider>(
        builder: (context, value, child) => ListView(
          children: value.languages!
              .map((e) => ListTile(
                    title: Text(e.label!),
                    trailing: context.locale == Locale(e.languageCode!, e.countryCode)
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(LineIcons.check, color: Colors.white, size: 20),
                            ),
                          )
                        : SizedBox.shrink(),
                    onTap: () {
                      UIProvider.instance(context).setLanguage(context, Locale(e.languageCode!, e.countryCode));
                    },
                  ))
              .toList(),
        ),
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }
}
