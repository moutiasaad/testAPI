import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_firebase/Classes/Demande.dart';
import 'package:test_firebase/Classes/Piece.dart';
import 'package:test_firebase/Commonpes/ButtonNavBar.dart';

class ListPiece extends StatefulWidget {
  const ListPiece({Key? key}) : super(key: key);

  @override
  State<ListPiece> createState() => _ListPieceState();
}

class _ListPieceState extends State<ListPiece> {
  List<Piece> pieces = [];
  List<Demande> Demandes =[];
  String title="";
  Future<void> getData() async {
    while (title =="") {
      await Future.delayed(Duration(seconds: 1));
    }
    fetchPiece();
  }
  Future<void> fetchPiece () async{
    final piece = FirebaseFirestore.instance.collection(title).withConverter(
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
    fetchDemande();
  }
  Future<void> fetchDemande() async{
    final demande = FirebaseFirestore.instance.collection("DemandePiece").withConverter(
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
        pieces = pieces.where((piece) {
          return Demandes.any((demande) => demande.ref != piece.ref);
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
      Navigator.pushNamed(context, '/CategorieListPieces');
      return true;
    },
    child : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Piece de rechange"),
      ),
      body: pieces!=Null ?ListView(
        children: pieces
            .map(
              (piece) => InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/DetailsPiece', arguments: {
                    'piece':piece,
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
      bottomNavigationBar: ButtonNavBar(selectedIndex: 1),
    ));
  }
}
