import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.name,
    required this.age,
    required this.lastname,
  });

  String name;
  int age;
  String lastname;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        name: json["name"],
        age: json["age"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "lastname": lastname,
      };
}
