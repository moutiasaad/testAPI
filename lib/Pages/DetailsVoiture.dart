import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase/Classes/Voiture.dart';
import 'package:test_firebase/Commonpes/ButtonNavBar.dart';

class DetailsVoiture extends StatefulWidget {
  const DetailsVoiture({Key? key}) : super(key: key);

  @override
  State<DetailsVoiture> createState() => _DetailsVoitureState();
}

class _DetailsVoitureState extends State<DetailsVoiture> {
  late Voiture? _voiture;
  late bool _session=false;
  late String? _catigoriee;
  late String? id ;
  Future<void> getId()async{
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        _session = true;
        id= prefs.getString('id')!;
      });
    }
  }
  Future<void> PasseDemande() async {
    if(_session==true){
      try{
        DateTime dateTime = DateTime.now();
        Timestamp _date= Timestamp.fromDate(dateTime);
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        Map<String , dynamic> DemandeData={
          'type':"Voiture",
          'date':_date,
          'userId':id,
          'nom':_voiture!.modele,
          'ref':_voiture!.numeroSerie,
          'prix':_voiture!.prix
        };
        await firestore.collection("DemandeVoiture").add(DemandeData);
        Navigator.pushNamed(context, '/Remerciements', arguments: {
          'type':_catigoriee
        });
      }
      catch (e){

      }
    }
    else{
      Navigator.pushNamed(context, '/login', arguments: {
        'type':"voiture",
        'voiture':_voiture
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getId();
  }
  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    _voiture = arguments['voiture'] as Voiture;
    _catigoriee= arguments['type'] as String;
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, '/ListVoiture', arguments: {
        'type':_catigoriee
      });
      return true;
    },
    child : Scaffold(
      appBar: AppBar(
        title: Text("Details de Voiture"),
        backgroundColor: Colors.red,
      ),
      body:SingleChildScrollView(
        child:Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child:Column(
              children: [
                Image.network(_voiture!.imageUrl),
                SizedBox(height: 10,
                ),
                Text(_voiture!.marque),
                SizedBox(height: 10,),
                Text(_voiture!.modele),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Annee Production:"),
                    SizedBox(width: 10,),
                    Text(_voiture!.anneeProduction.toDate().toString())
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("kilometrage:"),
                    SizedBox(width: 10,),
                    Text(_voiture!.kilometrage)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Couleur:"),
                    SizedBox(width: 10,),
                    Text(_voiture!.couleur)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Carburant:"),
                    SizedBox(width: 10,),
                    Text(_voiture!.carburant)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Cylindree"),
                    SizedBox(width: 10,),
                    Text(_voiture!.cylindree)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Puissance Fiscale:"),
                    SizedBox(width: 10,),
                    Text(_voiture!.puissanceFiscale)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Type Carrosserie:"),
                    SizedBox(width: 10,),
                    Text(_voiture!.typeCarrosserie)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("type Boite:"),
                    SizedBox(width: 10,),
                    Text(_voiture!.typeBoite)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("numero Serie:"),
                    SizedBox(width: 10,),
                    Text(_voiture!.numeroSerie)
                  ],
                ),
                SizedBox(height: 8.0),
                Text(_voiture!.prix.toString()+"£"),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed:  () async {
                    await PasseDemande();
                  },
                  style: ElevatedButton
                      .styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.black,
                    shape:
                    RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius:
                      BorderRadius
                          .circular(10.0),
                    ),
                  ),
                  child:Padding(
                      padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                      child:Text("Payez")
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: ButtonNavBar(selectedIndex: 0),
    ));
  }
}

