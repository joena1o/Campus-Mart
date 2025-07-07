import 'dart:convert';

class StateModel {
  String? id;
  int? countryId;
  int? stateId;
  String? state;

  StateModel({
    this.id,
    this.countryId,
    this.stateId,
    this.state,
  });

  factory StateModel.fromRawJson(String str) => StateModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
    id: json["_id"],
    countryId: json["country_id"],
    stateId: json["state_id"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "country_id": countryId,
    "state_id": stateId,
    "state": state,
  };
}
