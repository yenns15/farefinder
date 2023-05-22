import 'dart:convert';

TravelHistory travelHistoryFromJson(String str) => TravelHistory.fromJson(json.decode(str));

String travelHistoryToJson(TravelHistory data) => json.encode(data.toJson());

class TravelHistory {
    String id;
    String idCliente;
    String idConductor;
    String from;
    String to;
    int timestamp;
    double price;
    String calificacionesCliente;
    String calificacionesConductor;

    TravelHistory({
        required this.id,
        required this.idCliente,
        required this.idConductor,
        required this.from,
        required this.to,
        required this.timestamp,
        required this.price,
        required this.calificacionesCliente,
        required this.calificacionesConductor,
    });

    factory TravelHistory.fromJson(Map<String, dynamic> json) => TravelHistory(
        id: json["id"],
        idCliente: json["idCliente"],
        idConductor: json["idConductor"],
        from: json["from"],
        to: json["to"],
        timestamp: json["timestamp"],
        price: json["price"]?.toDouble(),
       calificacionesCliente: json["calificacionesCliente"],
        calificacionesConductor: json["calificacionesConductor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idCliente": idCliente,
        "idConductor": idConductor,
        "from": from,
        "to": to,
        "timestamp": timestamp,
        "price": price,
        "calificacionesCliente": calificacionesCliente,
        "calificacionesConductor": calificacionesConductor,
    };
}