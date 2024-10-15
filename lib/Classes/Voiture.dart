import 'package:cloud_firestore/cloud_firestore.dart';

class Voiture {
  final Timestamp anneeProduction;
  final String carburant;
  final String couleur;
  final String cylindree;
  final String imageUrl;
  final String kilometrage;
  final String marque;
  final String modele;
  final String numeroSerie;
  final String puissanceFiscale;
  final String typeBoite;
  final String typeCarrosserie;
  final String prix;

  Voiture({
    required this.anneeProduction,
    required this.carburant,
    required this.couleur,
    required this.cylindree,
    required this.imageUrl,
    required this.kilometrage,
    required this.marque,
    required this.modele,
    required this.numeroSerie,
    required this.puissanceFiscale,
    required this.typeBoite,
    required this.typeCarrosserie,
    required this.prix,
  });
  Map<String, dynamic> toJson() {
    return {
      'anneeProduction': anneeProduction,
      'carburant': carburant,
      'couleur': couleur,
      'cylindree': cylindree,
      'imageUrl': imageUrl,
      'kilometrage': kilometrage,
      'marque': marque,
      'modèle': modele,
      'numeroSerie': numeroSerie,
      'puissanceFiscale': puissanceFiscale,
      'typeBoite': typeBoite,
      'typeCarrosserie': typeCarrosserie,
      'prix':prix
    };
  }
  factory Voiture.fromJson(Map<String, dynamic> json) {
    return Voiture(
      anneeProduction: json['anneeProduction'] as Timestamp,
      carburant: json['carburant'] as String,
      couleur: json['couleur'] as String,
      cylindree: json['cylindree'] as String,
      imageUrl: json['imageUrl']! as String,
      kilometrage: json['kilometrage'] as String,
      marque: json['marque'] as String,
      modele: json['modele'] as String,
      numeroSerie: json['numeroSeries'] as String,
      puissanceFiscale: json['puissenseFiscale'] as String,
      typeBoite: json['typeBoite'] as String,
      typeCarrosserie: json['typeCarrosserie'] as String,
      prix: json['prix'] as String ,
    );
  }
}
