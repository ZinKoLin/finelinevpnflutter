import 'vpnServer.dart';

class VpnConfig extends VpnServerModel {
  VpnConfig({
    String? id,
    String? name,
    String? flag,
    String? country,
    String? slug,
    int? status,
    String? serverIp,
    String? port,
    String? protocol,
    this.username,
    this.password,
    this.config,
  }) : super(id: id, name: name, flag: flag, country: country, slug: slug, status: status, serverIp: serverIp, port: port, protocol: protocol);

  String? username;
  String? password;
  String? config;

  factory VpnConfig.fromJson(Map<String, dynamic> json) => VpnConfig(
        id: json["id"] == null ? null : json["id"].toString(),
        name: json["name"] == null ? null : json["name"],
        flag: json["flag"] == null ? null : json["flag"],
        country: json["country"] == null ? null : json["country"],
        slug: json["slug"] == null ? null : json["slug"],
        status: json["status"] == null ? null : json["status"],
        serverIp: json["server_ip"] == null ? null : json["server_ip"],
        port: json["port"] == null ? null : json["port"],
        protocol: json["protocol"] == null ? null : json["protocol"],
        username: json["username"] == null ? null : json["username"],
        password: json["password"] == null ? null : json["password"],
        config: json["config"] == null ? null : json["config"],
      );

  Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "password": password == null ? null : password,
        "slug": slug == null ? null : slug,
        "config": config == null ? null : config,
      };
}
