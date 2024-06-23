// To parse this JSON data, do
//
//     final modelListTiket = modelListTiketFromJson(jsonString);

import 'dart:convert';

ModelListTiket modelListTiketFromJson(String str) =>
    ModelListTiket.fromJson(json.decode(str));

String modelListTiketToJson(ModelListTiket data) => json.encode(data.toJson());

class ModelListTiket {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListTiket({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListTiket.fromJson(Map<String, dynamic> json) => ModelListTiket(
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
  String ticketName;
  String ticketPrice;
  String ticketImage;
  String ticketDesc;
  DateTime ticketDate;
  String ticketLoc;

  Datum({
    required this.id,
    required this.ticketName,
    required this.ticketPrice,
    required this.ticketImage,
    required this.ticketDesc,
    required this.ticketDate,
    required this.ticketLoc,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        ticketName: json["ticket_name"],
        ticketPrice: json["ticket_price"],
        ticketImage: json["ticket_image"],
        ticketDesc: json["ticket_desc"],
        ticketDate: DateTime.parse(json["ticket_date"]),
        ticketLoc: json["ticket_loc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_name": ticketName,
        "ticket_price": ticketPrice,
        "ticket_image": ticketImage,
        "ticket_desc": ticketDesc,
        "ticket_date": ticketDate.toIso8601String(),
        "ticket_loc": ticketLoc,
      };
}
