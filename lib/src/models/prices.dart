import 'dart:convert';

Prices pricesFromJson(String str) => Prices.fromJson(json.decode(str));

String pricesToJson(Prices data) => json.encode(data.toJson());

class Prices {
    double km;
    double min;
    double minValue;

    Prices({
        required this.km,
        required this.min,
        required this.minValue,
    });

    factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        km: json["km"]?.toDouble(),
        min: json["min"]?.toDouble(),
        minValue: json["minValue"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "km": km,
        "min": min,
        "minValue": minValue,
    };
}