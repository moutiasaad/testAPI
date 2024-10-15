import 'package:cloud_firestore/cloud_firestore.dart';
class Client {
  String email;
  String password;
  String nom;
  String prenom;
  String cin;
  String Adress;
  String telephone;
  Timestamp dateNaissance;

  Client({
   required this.email,
    required  this.password,
    required this.nom,
    required this.prenom,
    required this.cin,
    required this.Adress,
    required this.telephone,
    required this.dateNaissance,
  });

  // Convert the User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password':password,
      'nom':nom,
      'prenom':prenom,
      'cin': cin,
      'Adress':Adress,
      'telephone':telephone,
      'dateNaissance': dateNaissance,
    };
  }

  // Create a User object from a JSON map
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      email: json['email'] as String,
      password: json['password'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      cin: json['cin'] as String,
      Adress: json['Adress'] as String,
      telephone: json['telephone'] as String,
      dateNaissance: json['dateNaissance'] as Timestamp,
    );
  }
}
