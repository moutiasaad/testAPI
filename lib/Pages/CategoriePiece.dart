import 'package:flutter/material.dart';
import 'package:test_firebase/Classes/CategoriePiece.dart';
import 'package:test_firebase/Commonpes/ButtonNavBar.dart';

class CategorieListPieces extends StatefulWidget {
  const CategorieListPieces ({Key? key}) : super(key: key);

  @override
  State<CategorieListPieces> createState() => _CategorieListPiecesState();
}

class _CategorieListPiecesState extends State<CategorieListPieces> {
  final List<CategoriePiece> categoriePieces = [
    CategoriePiece(
      id: 1,
      title: 'VIDANGE',
      description: 'Description of product 1',
      image: 'vidange',
      mink: '/Vidange',
    ),
    CategoriePiece(
      id: 2,
      title: 'FREINAGE',
      description: 'Description of product 2',
      image: 'freinage',
      mink: '/Freinage',
    ),
    CategoriePiece(
      id: 3,
      title: 'DISTRIBUTION',
      description: 'Description of product 3',
      image: 'dist',
      mink: '/Distribution',
    ),
    CategoriePiece(
      id: 4,
      title: 'SUSPENSION',
      description: 'Description of product 2',
      image: 'amor',
      mink: '/Suspension',
    ),
    CategoriePiece(
      id: 5,
      title: 'REFROIDISSEMENT',
      description: 'Description of product 2',
      image: 'rad',
      mink: '/Refroid',
    ),
    CategoriePiece(
      id: 6,
      title: 'ACCESSOIRES',
      description: 'Description of product 2',
      image: 'accessoire',
      mink: '/Accessoires',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:   ()async {
          Navigator.pushNamed(context, '/CategorieListVoitures');
          return true;
    },
      child:  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Categorie Piece"),
        ),
        body: ListView(
          children: categoriePieces.map((categoriePiece) => InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/ListPiece', arguments: {
                'type':categoriePiece.title
              });
            },
            child: Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/Images/${categoriePiece.image}.png",
                    ),
                    Text(
                      categoriePiece.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(categoriePiece.description),
                  ],
                ),
              ),
            ),
          ),
          ).toList(),
        ),
        bottomNavigationBar: ButtonNavBar(selectedIndex: 1),
      ),
    ) ;
  }
}
