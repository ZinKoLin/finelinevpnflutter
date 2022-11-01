import 'package:nizvpn/core/models/model.dart';

class Language extends Model {
  Language({
    this.label,
    this.languageCode,
    this.countryCode,
  });

  String? label;
  String? languageCode;
  String? countryCode;
  factory Language.fromJson(Map<String, dynamic> json) => Language(
        label: json["label"] == null ? null : json["label"],
        languageCode: json["language_code"] == null ? null : json["language_code"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "label": label == null ? null : label,
        "language_code": languageCode == null ? null : languageCode,
        "country_code": countryCode == null ? null : countryCode,
      };
}
