import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/model.dart';
import '../provider/vpnProvider.dart';

class HttpConnection {
  final BuildContext context;

  VpnProvider? vpnProvider;

  HttpConnection(this.context) {
    vpnProvider = VpnProvider.instance(context);
  }

  Future post<T>(String url, {dynamic body, dynamic headers, bool pure = false}) async {
    try {
      var resp = await Dio().post(url, data: body, options: Options(headers: headers));

      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  Future get<T>(String url, {dynamic params, dynamic headers, bool pure = false}) async {
    try {
      var resp = await Dio().get(url + paramsToString(params), options: Options(headers: headers));

      if (pure) return resp.data;
      if (resp.data != null) {
        return ApiResponse.fromJson(resp.data);
      }
    } catch (e) {
      return null;
    }
  }

  String paramsToString(Map<String, String>? params) {
    if (params == null) return "";
    String output = "?";
    params.forEach((key, value) {
      output += "$key=$value&";
    });
    return output.substring(0, output.length - 1);
  }
}

class ApiResponse<T> extends Model {
  ApiResponse({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  T? data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"] ?? false,
        message: json["message"],
        data: json["data"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
      };
}
