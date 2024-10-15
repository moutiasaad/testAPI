import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase/Classes/Voiture.dart';
import 'package:test_firebase/Commonpes/ClientButtonNavBar.dart';


import '../../Commonpes/ButtonNavBar.dart';
class ListsVoiture extends StatefulWidget {
  const ListsVoiture({Key? key}) : super(key: key);

  @override
  State<ListsVoiture> createState() => _ListsVoitureState();
}

class _ListsVoitureState extends State<ListsVoiture> {
  List<Voiture> voitures = [];
  late String catigoree='';
  late String? id ;
  Future<void> getData() async {
    while (catigoree =="") {
      await Future.delayed(Duration(seconds: 1));
    }
    fetchVoitures();
  }
  Future<void> getId()async{
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        id= prefs.getString('id')!;
      });
      getData();
    }
    else{
    }
  }
  Future<void> fetchVoitures () async{

    final voiture = FirebaseFirestore.instance.collection(catigoree).where('id_user', isEqualTo: id).withConverter(
      fromFirestore: (snapshot, options) => Voiture.fromJson(snapshot.data()!),
      toFirestore: (voiture, options) => voiture.toJson(),
    );
    voiture.get().then((querySnapshot) {
      setState(() {
        voitures = querySnapshot.docs.map((doc) {
          return doc.data()!;
        }).toList();
      });
    });
  }
  Future<void> DeletPiece(String numeroSeries)async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                title: Text("Suppretion Piece"),
                content:  Text(""),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[900],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("Annuler"),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[900],
                    ),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(catigoree)
                          .where('numeroSeries', isEqualTo: numeroSeries)
                          .get();
                      try {
                        if (querySnapshot.docs.isNotEmpty) {
                          for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
                            await FirebaseFirestore.instance.collection(catigoree)
                                .doc(documentSnapshot.id)
                                .delete();
                          }
                        } else {

                        }
                      } catch (e) {
                        print('Error deleting document: $e');
                      }
                    },
                    child: Text("Supprimer"),
                  ),
                ]
            );
          },
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
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
    setState(() {
      catigoree = arguments['catigoree'] as String;
    });
    return WillPopScope(
        onWillPop: () async{
      Navigator.pushNamed(context, '/CategorieDeListVoitures');
      return true;
    },
    child : Scaffold(
      appBar: AppBar(
        title: Text("Votre Voiture"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/InseriVoiture',
          arguments: {
            'catigoree':catigoree
          });
        },
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add, // Specify the icon you want to use
          color: Colors.white, // Optional: Set the icon color
        ),
      ) ,
      body: ListView(
        children: voitures
            .map(
              (voiture) => InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/DetailsDeVoiture', arguments: {
                'voiture':voiture,
                'catigoree':catigoree,
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
                      voiture.imageUrl,
                    ),
                    Text(
                      voiture.marque,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(voiture.modele),
                    SizedBox(height: 8.0),
                    Text(voiture.prix.toString()+"£"),
                    IconButton(
                      onPressed: ()async{
                        DeletPiece(voiture.numeroSerie);
                      },
                      icon: Icon(Icons.delete),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
      bottomNavigationBar: ClientButtonNavBar(selectedIndex: 0),
    ));
  }
}
