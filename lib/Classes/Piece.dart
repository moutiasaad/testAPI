import 'package:cloud_firestore/cloud_firestore.dart';

class Piece {
  final Timestamp dateF;
  final String dureeV;
  final String etat;
  final String matiereF;
  final String nom;
  final String ref;
  final String imgeUrl;
  final String prix;
  Piece(
      {
      required this.dateF,
      required this.dureeV,
      required this.etat,
      required this.matiereF,
      required this.nom,
      required this.ref,
      required this.imgeUrl,
      required this.prix,
      });
  Map<String, dynamic> toJson() {
    return {
      'dateF':dateF,
      'dureeV':dureeV,
      'etat':etat,
      'matiereF':matiereF,
      'nom':nom,
      'ref':ref,
      'imageUrl':imgeUrl,
      'prix':prix
    };
  }
  factory Piece.fromJson(Map<String, dynamic> json) {
    return Piece(
        dateF: json['dateF'] as Timestamp,
        dureeV: json['dureeV'] as String,
        etat: json['etat'] as String,
        matiereF: json['matiereF'] as String,
        nom: json['nom'] as String,
        ref: json['ref'] as String,
        prix: json['prix']as String ,
        imgeUrl: json['imageUrl'] as String
    ) ;
  }
}
