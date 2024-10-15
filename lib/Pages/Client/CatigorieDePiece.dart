import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase/Classes/CategoriePiece.dart';
import 'package:test_firebase/Commonpes/ClientButtonNavBar.dart';

class CategorieDeListPieces extends StatefulWidget {
  const CategorieDeListPieces ({Key? key}) : super(key: key);

  @override
  State<CategorieDeListPieces> createState() => _CategorieDeListPiecesState();
}

class _CategorieDeListPiecesState extends State<CategorieDeListPieces> {
  late String? id;
  final List<CategoriePiece> categoriePieces = [
    CategoriePiece(
      id: 1,
      title: 'VIDANGE',
      description: 'Description of product 1',
      image: 'vidange', // Replace with the actual image path.
      mink: '/Vidange',
    ),
    CategoriePiece(
      id: 2,
      title: 'FREINAGE',
      description: 'Description of product 2',
      image: 'freinage', // Replace with the actual image path.
      mink: '/Freinage',
    ),
    CategoriePiece(
      id: 3,
      title: 'DISTRIBUTION',
      description: 'Description of product 3',
      image: 'dist', // Replace with the actual image path.
      mink: '/Distribution',
    ),
    CategoriePiece(
      id: 4,
      title: 'SUSPENSION',
      description: 'Description of product 2',
      image: 'amor', // Replace with the actual image path.
      mink: '/Suspension',
    ),
    CategoriePiece(
      id: 5,
      title: 'REFROIDISSEMENT',
      description: 'Description of product 2',
      image: 'rad', // Replace with the actual image path.
      mink: '/Refroid',
    ),
    CategoriePiece(
      id: 6,
      title: 'ACCESSOIRES',
      description: 'Description of product 2',
      image: 'accessoire', // Replace with the actual image path.
      mink: '/Accessoires',
    ),
  ];
  Future<void> getId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        id = prefs.getString('id')!;
      });
    }
    else{
      Navigator.pushNamed(context, '/login');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, '/CategorieDeListVoitures');
      return true;
    },
    child :  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Categorie Piece"),
      ),
      body: ListView(
        children: categoriePieces.map((categoriePiece) => InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/ListsPiece', arguments: {
              'catigoree':categoriePiece.title
            });
          },
          child: Card(
            elevation: 4.0, // Card elevation (shadow)
            margin: EdgeInsets.all(16.0), // Card margin
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
      bottomNavigationBar: ClientButtonNavBar(selectedIndex: 1),
      )
    );
  }
}
