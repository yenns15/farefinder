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
        required this.token
    });

    String id;
    String username;
    String email;
    String password;
    String plate;
    String token;

    factory Conductor.fromJson(Map<String, dynamic> json) => Conductor(
        id: json["id"]??'',
        username: json["username"]??'',
        email: json["email"]??'',
        password: json["password"]??'',
        plate: json["plate"],
        token: json["token"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "plate": plate,
         "token": token,
    };
}