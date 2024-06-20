// To parse this JSON data, do
//
//     final modelBudaya = modelBudayaFromJson(jsonString);

import 'dart:convert';

ModelBudaya modelBudayaFromJson(String str) => ModelBudaya.fromJson(json.decode(str));

String modelBudayaToJson(ModelBudaya data) => json.encode(data.toJson());

class ModelBudaya {
    bool isSuccess;
    String message;
    List<Datum> data;

    ModelBudaya({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelBudaya.fromJson(Map<String, dynamic> json) => ModelBudaya(
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
    String pulau;

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
        pulau: json["pulau"],
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
        "pulau": pulau,
    };
}
