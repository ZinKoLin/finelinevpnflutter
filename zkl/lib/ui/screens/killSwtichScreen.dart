import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../core/provider/adsProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/warna.dart';
import '../../core/utils/NizVPN.dart';
import '../components/customDivider.dart';

class KillSwitchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("setting_killswitch".tr()),
        leading: IconButton(
          icon: Icon(LineIcons.angleLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        children: [
          Text(
            "killswitch_title".tr(),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          ColumnDivider(space: 30),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("1. ${"killswitch_step1".tr()}"),
                ColumnDivider(),
                Text("2. ${"killswitch_step2".tr().replaceAll("\$appname", appname)}"),
                ColumnDivider(),
                Text("3. ${"killswitch_step3".tr()}"),
                ColumnDivider(space: 15),
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        StadiumBorder(),
                      ),
                      backgroundColor: MaterialStateProperty.all(primaryColor)),
                  child: Text(
                    "${"killswitch_opensetting".tr()}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: NVPN.openKillSwitch,
                )
              ],
            ),
          ),
          ColumnDivider(),
          Text(
            "${"killswitch_note".tr()}",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          )
        ],
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }
}
