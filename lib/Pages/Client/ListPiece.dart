import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase/Commonpes/ClientButtonNavBar.dart';

import '../../Classes/Piece.dart';
import '../../Commonpes/ButtonNavBar.dart';
class ListsPiece extends StatefulWidget {
  const ListsPiece({Key? key}) : super(key: key);

  @override
  State<ListsPiece> createState() => _ListsPieceState();
}

class _ListsPieceState extends State<ListsPiece> {
  List<Piece> pieces = [];
  late String catigoree='';
  late String? id ;
  Future<void> getData() async {
    while (catigoree =="") {
      await Future.delayed(Duration(seconds: 1));
    }
    fetchPieces();
  }
  Future<void> getId()async{
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        id= prefs.getString('id')!;
      });
      getData();
    }
  }
  Future<void> fetchPieces () async{
    final piece = FirebaseFirestore.instance.collection(catigoree).where('id_user', isEqualTo: id).withConverter(
      fromFirestore: (snapshot, options) => Piece.fromJson(snapshot.data()!),
      toFirestore: (piece, options) => piece.toJson(),
    );
    piece.get().then((querySnapshot) {
      setState(() {
        pieces = querySnapshot.docs.map((doc) {
          return doc.data()!;
        }).toList();
      });
    });
  }
  Future<void> DeletPiece(String ref)async{
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
                        .where('ref', isEqualTo: ref)
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
      Navigator.pushNamed(context, '/CategorieDeListPieces');
      return true;
    },
    child : Scaffold(
      appBar: AppBar(
        title: Text("Votre Pieces"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/InseriPiece',
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
      body:pieces!=null? ListView(
        children: pieces
            .map(
              (piece) => InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/DetailsDePiece', arguments: {
                'piece':piece,
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
                      piece.imgeUrl,
                    ),
                    Text(
                      piece.nom,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(piece.etat),
                    SizedBox(height: 8.0),
                    Text(piece.prix.toString()+"£"),
                    IconButton(
                        onPressed: ()async{
                          DeletPiece(piece.ref);
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
      ):Center(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: ClientButtonNavBar(selectedIndex: 1),
    ));
  }
}
