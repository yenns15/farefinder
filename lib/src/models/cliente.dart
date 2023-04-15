import 'dart:convert';

Cliente clienteFromJson(String str) => Cliente.fromJson(json.decode(str));

String clienteToJson(Cliente data) => json.encode(data.toJson());

class Cliente {
  
  String id;
    String username;
    String email;
    String password;

    Cliente({
        required this.id,
        required this.username,
        required this.email,
        required this.password,
    });

    


    factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
    };
}
