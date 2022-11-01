import 'package:flutter/material.dart';

import '../models/vpnConfig.dart';
import '../models/vpnServer.dart';
import '../resources/environment.dart';
import 'httpConnection.dart';

class VpnServerHttp extends HttpConnection {
  VpnServerHttp(BuildContext context) : super(context);

  Future<List<VpnServer>?> allServer({int? page}) async {
    ApiResponse? resp;
    if (page == null) {
      resp = await (get(api + "allservers"));
    } else {
      resp = await (get(api + "allservers", params: {"page": page.toString()}));
    }
    if (resp!.success!) {
      return resp.data.map((e) => VpnServer.fromJson(e)).toList().cast<VpnServer>();
    }
    return [];
  }

  Future<List<VpnServer>?> allProServer({int? page}) async {
    ApiResponse? resp;
    if (page == null) {
      resp = await (get(api + "allservers/pro"));
    } else {
      resp = await (get(api + "allservers/pro", params: {"page": page.toString()}));
    }
    if (resp?.success ?? false) {
      return resp!.data.map((e) => VpnServer.fromJson(e)).toList().cast<VpnServer>();
    }
    return [];
  }

  Future<List<VpnServer>?> allFreeServer({int? page}) async {
    ApiResponse? resp;
    if (page == null) {
      resp = await (get(api + "allservers/free"));
    } else {
      resp = await (get(api + "allservers/free", params: {"page": page.toString()}));
    }
    if (resp?.success ?? false) {
      return resp!.data.map((e) => VpnServer.fromJson(e)).toList().cast<VpnServer>();
    }
    return [];
  }

  Future<VpnConfig?> randomVpn() async {
    ApiResponse? resp = await (get(api + "detail/random"));
    if (resp?.success ?? false) {
      return VpnConfig.fromJson(resp!.data);
    }
    return null;
  }

  Future<VpnConfig?> detailVpn(VpnServerModel vpnServer) async {
    ApiResponse? resp = await (get(
      api + "detail/${vpnServer.slug}",
      params: {
        "protocol": vpnServer.protocol == "tcp" ? "tcp" : "udp",
      },
    ));
    if (resp?.success ?? false) {
      return VpnConfig.fromJson(resp!.data);
    }
    return null;
  }
}
