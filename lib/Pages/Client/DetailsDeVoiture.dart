import 'package:flutter/material.dart';
import '../../Classes/Voiture.dart';
import '../../Commonpes/ClientButtonNavBar.dart';
class DetailsDeVoiture extends StatefulWidget {
  const DetailsDeVoiture({Key? key}) : super(key: key);

  @override
  State<DetailsDeVoiture> createState() => _DetailsDeVoitureState();
}

class _DetailsDeVoitureState extends State<DetailsDeVoiture> {
  late Voiture? _voiture;
  late bool _session=false;
  late String catigoree="";
  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    _voiture = arguments['voiture'] as Voiture;
    catigoree = arguments['catigoree'] as String;
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, '/ListsVoiture',arguments: {
        'catigoree':catigoree
      });
      return true;
    },
    child : Scaffold(
      appBar: AppBar(
        title: Text("Details de Voiture"),
        backgroundColor: Colors.red,
      ),
      body:SingleChildScrollView(
        child: Card(
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
              ],
            ),
          ),
        ),
      ) ,
      bottomNavigationBar: ClientButtonNavBar(selectedIndex: 0),
    ));
  }
}
