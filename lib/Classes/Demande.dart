import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Demande {
  Timestamp date;
  String nom;
  String prix;
  String ref;
  String type;
  String userId;

  Demande({
    required this.date,
    required this.nom,
    required this.prix,
    required this.ref,
    required this.type,
    required this.userId,
  });
  factory Demande.fromJson(Map<String, dynamic> json) {
    return Demande(
      date: json['date'],
      nom: json['nom'],
      prix: json['prix'],
      ref: json['ref'],
      type: json['type'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'nom': nom,
      'prix': prix,
      'ref': ref,
      'type': type,
      'userId': userId,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory Demande.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Demande.fromJson(jsonMap);
  }
}