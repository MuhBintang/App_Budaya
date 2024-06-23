// To parse this JSON data, do
//
//     final modelListBudaya = modelListBudayaFromJson(jsonString);

import 'dart:convert';

ModelListBudaya modelListBudayaFromJson(String str) =>
    ModelListBudaya.fromJson(json.decode(str));

String modelListBudayaToJson(ModelListBudaya data) =>
    json.encode(data.toJson());

class ModelListBudaya {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListBudaya({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListBudaya.fromJson(Map<String, dynamic> json) =>
      ModelListBudaya(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String provinsi;
  String rumahAdat;
  String deskripsi;
  String tari;
  String senjata;
  String suku;
  String makanan;
  String pakaian;
  Pulau pulau;

  Datum({
    required this.id,
    required this.provinsi,
    required this.rumahAdat,
    required this.deskripsi,
    required this.tari,
    required this.senjata,
    required this.suku,
    required this.makanan,
    required this.pakaian,
    required this.pulau,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        provinsi: json["provinsi"],
        rumahAdat: json["rumah_adat"],
        deskripsi: json["deskripsi"],
        tari: json["tari"],
        senjata: json["senjata"],
        suku: json["suku"],
        makanan: json["makanan"],
        pakaian: json["pakaian"],
        pulau: pulauValues.map[json["pulau"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provinsi": provinsi,
        "rumah_adat": rumahAdat,
        "deskripsi": deskripsi,
        "tari": tari,
        "senjata": senjata,
        "suku": suku,
        "makanan": makanan,
        "pakaian": pakaian,
        "pulau": pulauValues.reverse[pulau],
      };
}

enum Pulau { JAWA, KALIMANTAN, PAPUA, SULAWESI, SUMATRA }

final pulauValues = EnumValues({
  "jawa": Pulau.JAWA,
  "kalimantan": Pulau.KALIMANTAN,
  "papua": Pulau.PAPUA,
  "sulawesi": Pulau.SULAWESI,
  "sumatra": Pulau.SUMATRA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
