import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import '../https/vpnServerHttp.dart';
import '../provider/vpnProvider.dart';
import '../utils/NizVPN.dart';
import 'model.dart';

abstract class VpnServerModel extends Model {
  final String? id;
  final String? name;
  final String? flag;
  final String? country;
  final String? slug;
  final int? status;
  final String? serverIp;
  final String? port;
  final String? protocol;

  VpnServerModel({this.id, this.name, this.flag, this.country, this.slug, this.status, this.serverIp, this.port, this.protocol});

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "flag": flag == null ? null : flag,
        "country": country == null ? null : country,
        "slug": slug == null ? null : slug,
        "status": status == null ? null : status,
        "server_ip": serverIp == null ? null : serverIp,
        "port": port == null ? null : port,
        "protocol": protocol == null ? null : protocol,
      };
  void refreshConfig(BuildContext context) async {
    VpnProvider provider = VpnProvider.instance(context);
    var resp = await CustomProgressDialog.future(
      context,
      future: VpnServerHttp(context).detailVpn(provider.vpnConfig!),
      dismissable: false,
      loadingWidget: Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
        ),
      ),
    );

    if (resp != null) {
      provider.vpnConfig = resp;
      if (provider.isConnected ?? false) NVPN.stopVpn();
      Navigator.pop(context);
    } else {
      NAlertDialog(
        title: Text("error_server_title".tr()),
        content: Text("error_server_desc".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("understand".tr()),
            style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
          )
        ],
      ).show(context);
    }
  }
}

class VpnServer extends VpnServerModel {
  VpnServer({
    String? id,
    String? name,
    String? flag,
    String? country,
    String? slug,
    int? status,
    String? serverIp,
    String? port,
    String? protocol,
  }) : super(id: id, name: name, flag: flag, country: country, slug: slug, status: status, serverIp: serverIp, port: port, protocol: protocol);

  factory VpnServer.fromJson(Map<String, dynamic> json) => VpnServer(
        id: json["id"] == null ? null : json["id"].toString(),
        name: json["name"] == null ? null : json["name"],
        flag: json["flag"] == null ? null : json["flag"],
        country: json["country"] == null ? null : json["country"],
        slug: json["slug"] == null ? null : json["slug"],
        status: json["status"] == null ? null : json["status"],
        serverIp: json["server_ip"] == null ? null : json["server_ip"],
        port: json["port"] == null ? null : json["port"],
        protocol: json["protocol"] == null ? null : json["protocol"],
      );
}
