import 'dart:convert';

Conductor conductorFromJson(String str) => Conductor.fromJson(json.decode(str));

String conductorToJson(Conductor data) => json.encode(data.toJson());

class Conductor {
    Conductor({
        required this.id,
        required this.username,
        required this.email,
        required this.password,
        required this.plate,
    });

    String id;
    String username;
    String email;
    String password;
    String plate;

    factory Conductor.fromJson(Map<String, dynamic> json) => Conductor(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        plate: json["plate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "plate": plate,
    };
}