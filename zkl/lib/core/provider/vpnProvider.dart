import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import '../../ui/screens/subscriptionDetailScreen.dart';
import '../https/vpnServerHttp.dart';
import '../models/vpnConfig.dart';
import '../models/vpnServer.dart';
import '../models/vpnStatus.dart';
import '../utils/NizVPN.dart';
import '../utils/preferences.dart';

class VpnProvider extends ChangeNotifier {
  VpnConfig? _vpnConfig;
  String? _vpnStage;
  VpnStatus? _vpnStatus;

  DateTime? _proLimitDate;

  late StreamSubscription vpnStatusStream, vpnStageStream;

  void initialize() {
    NVPN.initialize().then((value) {
      if (value == "") value = NVPN.vpnDisconnected;
      vpnStage = value;
    });
    vpnStatusStream = NVPN.vpnStatusSnapshot().listen((event) {
      vpnStatus = event;
    });
    vpnStageStream = NVPN.vpnStageSnapshot().listen((event) {
      vpnStage = event;
    });
  }

  void deleteStream() {
    vpnStatusStream.cancel();
    vpnStageStream.cancel();
  }

  ///Refresh everything (Pro status, VPNStage and VPN Servers)
  static Future<void> refreshInfoVPN(BuildContext context, [String? stage]) async {
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.vpnConfig == null) {
      await Preferences.init().then((pref) async {
        if (pref.vpnToken != null) {
          var resp = await vpnProvider.setConfig(context, pref.vpnToken, pref.protocol);
          if (resp != null) {
            if ((resp.status ?? 0) == 1 && !vpnProvider.isPro) {
              if (vpnProvider.isConnected ?? false) {
                NVPN.stopVpn();
                renewSubs(context);
              }
            }
          } else {
            await vpnProvider.setRandom(context);
          }
        } else {
          await vpnProvider.setRandom(context);
        }
      });
    }
  }

  set vpnStatus(VpnStatus? vpnStatus) {
    _vpnStatus = vpnStatus;
    notifyListeners();
  }

  ///Set Pro limit date and hit the notify (do it after init the purchase information)
  set proLimitDate(DateTime? time) {
    _proLimitDate = time;
    notifyListeners();
  }

  ///Set current VPNConfig and hit the notify
  set vpnConfig(VpnConfig? vpnConfig) {
    _vpnConfig = vpnConfig;
    notifyListeners();
    if (vpnConfig != null)
      Preferences.init().then(
        (value) => value
          ..saveVpnToken(vpnConfig.slug ?? "")
          ..saveProtocol(vpnConfig.protocol ?? "udp"),
      );
  }

  ///Set current VPNStage and hit the notify
  set vpnStage(String? stage) {
    _vpnStage = stage;
    notifyListeners();
  }

  ///Set VPNConfig with random configuration that taken from Server!
  Future<void> setRandom(BuildContext context) async {
    var resp = await VpnServerHttp(context).randomVpn();
    if (resp != null) vpnConfig = resp;
  }

  ///Set VPNConfig that taken from Server by Slug
  Future<VpnConfig?> setConfig(BuildContext context, String? slug, String? protocol) async {
    var resp = await VpnServerHttp(context).detailVpn(VpnServer(slug: slug, protocol: protocol));
    if (resp != null) vpnConfig = resp;
    return resp;
  }

  ///Current VPNConfig
  VpnConfig? get vpnConfig => _vpnConfig;

  ///Current Stage of connection
  String? get vpnStage {
    if (_vpnStage?.toUpperCase() == "INVALID") {
      _vpnStage = "DISCONNECTED";
    }
    return _vpnStage?.toLowerCase();
  }

  ///Check if VPN is Connected
  bool? get isConnected => (_vpnStage ?? "Disconnected").toUpperCase() == "CONNECTED";

  ///Check if User is PRO
  bool get isPro => proLimitDate != null ? DateTime.now().isBefore(proLimitDate!) : false;

  ///Get pro limit date
  DateTime? get proLimitDate => _proLimitDate;

  VpnStatus? get vpnStatus => _vpnStatus;

  ///Dialog to tell that user's pro subscription is expired
  static Future renewSubs(BuildContext context, {String? title, String? message}) => NAlertDialog(
        content: Text(message ?? "pro_expired".tr()),
        title: Text(title ?? "ops".tr()),
        actions: [
          TextButton(
            style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
            child: Text("renew".tr()),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubscriptionDetailScreen()));
            },
          ),
          TextButton(
            style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
            child: Text("continue_as_free".tr()),
            onPressed: () {
              VpnProvider vpnProvider = VpnProvider.instance(context);
              vpnProvider.vpnConfig = null;
              Navigator.pop(context);
            },
          ),
        ],
      ).show(context);

  static VpnProvider instance(BuildContext context) => Provider.of(context, listen: false);
}
