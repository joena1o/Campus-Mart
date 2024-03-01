import 'dart:convert';

class CountryModel {
  String? id;
  String? countryModelId;
  String? name;
  String? countryCode;

  CountryModel({
    this.id,
    this.countryModelId,
    this.name,
    this.countryCode,
  });

  factory CountryModel.fromRawJson(String str) => CountryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    id: json["_id"],
    countryModelId: json["id"],
    name: json["name"],
    countryCode: json["country_code"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "id": countryModelId,
    "name": name,
    "country_code": countryCode,
  };
}
