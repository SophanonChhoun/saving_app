import 'dart:convert';

AuthResponse AuthResponseFromMap(String str) =>
    AuthResponse.fromMap(json.decode(str));

String AuthResponseToMap(AuthResponse data) => json.encode(data.toMap());

class AuthResponse {
  AuthResponse({
    this.id,
    this.name,
    this.email,
    this.token,
  });

  String id;
  String name;
  String email;
  String token;

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "token": token == null ? null : token,
      };
}
