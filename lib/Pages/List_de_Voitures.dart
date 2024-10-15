import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_firebase/Classes/Demande.dart';
import 'package:test_firebase/Classes/Voiture.dart';

import '../Commonpes/ButtonNavBar.dart';

class ListVoiture extends StatefulWidget {
  const ListVoiture({Key? key}) : super(key: key);

  @override
  State<ListVoiture> createState() => _ListVoitureState();
}

class _ListVoitureState extends State<ListVoiture> {
  List<Voiture> Voitures = [];
  List<Demande> Demandes =[];
  String title="" ;
  Future<void> getData() async {
    while (title =="") {
      await Future.delayed(Duration(seconds: 1));
    }
    fetchVoitures();
  }

  Future<void> fetchVoitures () async{
    final voiture = FirebaseFirestore.instance.collection(title).withConverter(
      fromFirestore: (snapshot, options) => Voiture.fromJson(snapshot.data()!),
      toFirestore: (voiture, options) => voiture.toJson(),
    );
    voiture.get().then((querySnapshot) {
      setState(() {
        Voitures = querySnapshot.docs.map((doc) {
          return doc.data()!;
        }).toList();
      });
    });
    fetchDemande();
  }
  Future<void> fetchDemande() async{
    final demande = FirebaseFirestore.instance.collection("DemandeVoiture").withConverter(
      fromFirestore: (snapshot, options) => Demande.fromJson(snapshot.data()!),
      toFirestore: (demande, options) => demande.toJson(),
    );
    demande.get().then((querySnapshot) {
      setState(() {
        Demandes = querySnapshot.docs.map((doc) {
          return doc.data()!;
        }).toList();
      });
      setState(() {
        Voitures = Voitures.where((voiture) {
          return Demandes.any((demande) => demande.ref != voiture.numeroSerie);
        }).toList();
      });
    });

  }

@override
void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    setState(() {
      title = arguments['type'] as String;
    });
    return WillPopScope(
        onWillPop: () async{
      Navigator.pushNamed(context, '/CategorieListVoitures');
      return true;
    },
      child :Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("List de Voitures"),
      ),
      body:Voiture!=Null? ListView(
        children: Voitures.map(
          (Voiture) => InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/DetailsVoiture', arguments: {
                'voiture':Voiture,
                'type':title,
              });
            },
            child: Card(
              elevation: 4.0, // Card elevation (shadow)
              margin: EdgeInsets.all(16.0), // Card margin
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.network(
                      Voiture.imageUrl,
                    ),
                    Text(
                      Voiture.marque,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(Voiture.modele),
                    SizedBox(height: 8.0),
                    Text(Voiture.prix.toString()+"£"),
                  ],
                ),
              ),
            ),
          ),
        ).toList(),
      ):Center(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: ButtonNavBar(selectedIndex: 0),
    ));
  }
}
