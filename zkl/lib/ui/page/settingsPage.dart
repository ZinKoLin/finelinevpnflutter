import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/provider/vpnProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/nerdVpnIcons.dart';
import '../components/customDivider.dart';
import '../screens/aboutScreen.dart';
import '../screens/killSwtichScreen.dart';
import '../screens/languagesScreen.dart';
import '../screens/subscriptionDetailScreen.dart';

class PengaturanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("setting_app".tr(), style: TextStyle(fontSize: 12, color: Colors.grey)),
                  FutureBuilder<AndroidDeviceInfo>(
                    future: DeviceInfoPlugin().androidInfo,
                    builder: (context, snapshot) {
                      if (Platform.isIOS) return SizedBox.shrink();
                      if (snapshot.hasData) {
                        if (snapshot.data!.version.sdkInt > 24) {
                          return ListTile(
                            title: Text("setting_killswitch".tr()),
                            leading: Icon(NerdVPNIcon.settings, color: Colors.black),
                            onTap: () => _killSwitchClick(context),
                          );
                        }
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Consumer<VpnProvider>(
                    builder: (context, value, child) {
                      return (value.isPro)
                          ? SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ListTile(
                                //   title: Text("setting_gopremium".tr()),
                                //   leading: Icon(LineIcons.gift, color: Colors.black),
                                //   onTap: () => _subscriptionClick(context),
                                // )
                              ],
                            );
                    },
                  ),
                  ListTile(
                    title: Text("setting_language".tr()),
                    leading: Icon(LineIcons.flag, color: Colors.black),
                    onTap: () => _language(context),
                  ),
                  ListTile(
                    title: Text("setting_checkupdate".tr()),
                    leading: Icon(LineIcons.download, color: Colors.black),
                    onTap: () => _checkUpdateClick(context),
                  ),
                  // Text("setting_vpn".tr(), style: TextStyle(fontSize: 12, color: Colors.grey)),
                  // ListTile(
                  //   title: Text("setting_whitelist".tr()),
                  //   leading: Icon(LineIcons.android, color: Colors.black),
                  //   onTap: () => _whiteListApps(context),
                  // ),
                  Text("setting_aboutus".tr(), style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ListTile(
                    title: Text("setting_privacypolicy".tr()),
                    leading: Icon(LineIcons.userShield, color: Colors.black),
                    onTap: () => _privacyPolicyClick(context),
                  ),
                  ListTile(
                    title: Text("setting_tos".tr()),
                    leading: Icon(LineIcons.stickyNote, color: Colors.black),
                    onTap: _tosClick,
                  ),
                  ListTile(
                    title: Text("about".tr()),
                    leading: Icon(LineIcons.infoCircle, color: Colors.black),
                    onTap: () => _aboutClick(context),
                  ),
                  ListTile(
                    title: Text("setting_rateus".tr()),
                    leading: Icon(LineIcons.star, color: Colors.black),
                    onTap: _rateUsClick,
                  ),
                  ColumnDivider(space: 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _language(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesScreen()));
  }

  void _killSwitchClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => KillSwitchScreen()));
  }

  void _subscriptionClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionDetailScreen()));
  }

  void _checkUpdateClick(BuildContext context) async {
    AppUpdateInfo? resp = await CustomProgressDialog.future(
      context,
      future: InAppUpdate.checkForUpdate(),
      loadingWidget: Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );

    if (resp?.updateAvailability as bool? ?? false) {
      if (resp!.flexibleUpdateAllowed) {
        return InAppUpdate.startFlexibleUpdate().then((value) => InAppUpdate.completeFlexibleUpdate());
      }
      if (resp.immediateUpdateAllowed) {
        InAppUpdate.performImmediateUpdate();
        return;
      }
    } else {
      NAlertDialog(
        title: Text("no_update".tr()),
        content: Text("latest_version".tr()),
        actions: [
          TextButton(
            child: Text("great".tr()),
            style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show(context);
    }
  }

  void _rateUsClick() async {
    await InAppReview.instance.openStoreListing(appStoreId: appstoreId);
  }

  Widget _customAppBarWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "settings".tr(),
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _tosClick() {
    launch("https://nerdvpn.laskarmedia.id/term-of-services/");
  }

  void _privacyPolicyClick(context) {
    launch("https://nerdvpn.laskarmedia.id/privacy-policy-2/");
  }

  void _aboutClick(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
  }
}
