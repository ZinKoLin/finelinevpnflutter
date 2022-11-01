import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nizvpn/core/resources/environment.dart';
import 'package:provider/provider.dart';

import 'vpnProvider.dart';

class AdsProvider extends ChangeNotifier {
  InterstitialAd? intersAd1;
  InterstitialAd? intersAd2;
  InterstitialAd? intersAd3;

  bool _footerBannerShow = false;
  dynamic _bannerAd;

  set footBannerShow(bool value) {
    _footerBannerShow = value;
    notifyListeners();
  }

  bool get footBannerShow => !showAds ? false : _footerBannerShow;

  get bannerIsAvailable => _bannerAd != null;

  InterstitialAd _intersAd1Create() => InterstitialAd(
        unitId: inters1,
        loadTimeout: Duration(seconds: 8),
      )..onEvent.listen(
          (event) {
            switch (event.keys.first) {
              case FullScreenAdEvent.closed:
                intersAd1!.dispose();
                intersAd1 = _intersAd1Create();
                intersAd1!.load();
                break;
              default:
            }
          },
        );
  InterstitialAd _intersAd2Create() => InterstitialAd(
        unitId: inters2,
        loadTimeout: Duration(seconds: 8),
      )..onEvent.listen((event) {
          switch (event.keys.first) {
            case FullScreenAdEvent.closed:
              intersAd2!.dispose();
              intersAd2 = _intersAd1Create();
              intersAd2!.load();
              break;
            default:
          }
        });
  InterstitialAd _intersAd3Create() => InterstitialAd(
        unitId: inters3,
        loadTimeout: Duration(seconds: 8),
      )..onEvent.listen((event) {
          switch (event.keys.first) {
            case FullScreenAdEvent.closed:
              intersAd3!.dispose();
              intersAd3 = _intersAd1Create();
              intersAd3!.load();
              break;
            default:
          }
        });
  static void initAds(BuildContext context) {
    if (!showAds) return;
    AdsProvider adsProvider = AdsProvider.instance(context);

    adsProvider.intersAd1 = adsProvider._intersAd1Create();
    adsProvider.intersAd2 = adsProvider._intersAd2Create();
    adsProvider.intersAd3 = adsProvider._intersAd3Create();

    adsProvider.intersAd1?.load();
    adsProvider.intersAd2?.load();
    adsProvider.intersAd3?.load();
  }

  void showAd1(BuildContext context) async {
    if (!showAds) return;
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) return;
    if ((intersAd1?.isAvailable) ?? false) {
      intersAd1?.show();
    } else {
      intersAd1?.load();
    }
  }

  void showAd2(BuildContext context) async {
    if (!showAds) return;
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) return;
    if ((intersAd2?.isAvailable) ?? false) {
      intersAd2?.show();
    } else {
      intersAd2?.load();
    }
  }

  void showAd3(BuildContext context) async {
    if (!showAds) return;
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) return;
    if ((intersAd3?.isAvailable) ?? false) {
      intersAd3?.show();
    } else {
      intersAd3?.load();
    }
  }

  static Widget adWidget(BuildContext context, {String? bannerId, BannerSize? adSize}) {
    if (!showAds) return SizedBox.shrink();
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) {
      return SizedBox.shrink();
    } else {
      // return SizedBox.shrink();
      return BannerAd(
        unitId: bannerId ?? banner1,
        size: adSize ?? BannerSize.ADAPTIVE,
      );
      // return BannerAd(adUnitId: bannerId ?? banner1, adSize: adsize);
    }
  }

  static Widget adbottomSpace() {
    if (!showAds) return SizedBox.shrink();
    return Consumer<AdsProvider>(
      builder: (context, value, child) => value.footBannerShow ? SizedBox(height: 60) : SizedBox.shrink(),
    );
  }

  void removeBanner() {
    if (!showAds) return;
    footBannerShow = false;
    _bannerAd.dispose();
    _bannerAd = null;
  }

  static AdsProvider instance(BuildContext context) => Provider.of(context, listen: false);
}
