// To parse this JSON data, do
//
//     final modelFavorite = modelFavoriteFromJson(jsonString);

import 'dart:convert';

ModelFavorite modelFavoriteFromJson(String str) => ModelFavorite.fromJson(json.decode(str));

String modelFavoriteToJson(ModelFavorite data) => json.encode(data.toJson());

class ModelFavorite {
    bool isSuccess;
    String message;
    List<Datum> data;

    ModelFavorite({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelFavorite.fromJson(Map<String, dynamic> json) => ModelFavorite(
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
    String ticketDesc;
    String ticketDate;
    String ticketLoc;
    String ticketImage;

    Datum({
        required this.id,
        required this.ticketName,
        required this.ticketPrice,
        required this.ticketDesc,
        required this.ticketDate,
        required this.ticketLoc,
        required this.ticketImage,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        ticketName: json["ticket_name"],
        ticketPrice: json["ticket_price"],
        ticketDesc: json["ticket_desc"],
        ticketDate: json["ticket_date"],
        ticketLoc: json["ticket_loc"],
        ticketImage: json["ticket_image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_name": ticketName,
        "ticket_price": ticketPrice,
        "ticket_desc": ticketDesc,
        "ticket_date": ticketDate,
        "ticket_loc": ticketLoc,
        "ticket_image": ticketImage,
    };
}
