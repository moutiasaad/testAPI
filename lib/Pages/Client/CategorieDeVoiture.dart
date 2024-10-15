import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase/Classes/Cat%C3%A9gorieVoiture.dart';
import 'package:test_firebase/Commonpes/ClientButtonNavBar.dart';

class CategorieDeListVoitures extends StatefulWidget {
  const CategorieDeListVoitures({Key? key}) : super(key: key);

  @override
  State<CategorieDeListVoitures> createState() => _CategorieDeListVoituresState();
}
class _CategorieDeListVoituresState extends State<CategorieDeListVoitures> {
  late String? id;
  List<CategorieVoiture> categorieVoitures =[
    CategorieVoiture(
      id: 1,
      title: 'mini-citadines',
      description: 'Description of product 1',
      image: 'fiat', // You should provide the actual image path here.
      mink: '/Mini',
    ),
    CategorieVoiture(
      id: 2,
      title: 'petites voitures',
      description: 'Description of product 2',
      image: 'i20', // You should provide the actual image path here.
      mink: '/Petite',
    ),
    CategorieVoiture(
      id: 3,
      title: 'compactes',
      description: 'Description of product 3',
      image: 'golf7', // You should provide the actual image path here.
      mink: '/Compacte',
    ),
    CategorieVoiture(
      id: 4,
      title: 'grosses voitures',
      description: 'Description of product 2',
      image: 'classA', // You should provide the actual image path here.
      mink: '/Grosses',
    ),
    CategorieVoiture(
      id: 5,
      title: 'voitures de prestige',
      description: 'Description of product 2',
      image: 'ClasseE', // You should provide the actual image path here.
      mink: '/Prestige',
    ),
    CategorieVoiture(
      id: 6,
      title: 'SUV',
      description: 'Description of product 2',
      image: 'kuga', // You should provide the actual image path here.
      mink: '/SUV',
    ),
    CategorieVoiture(
      id: 7,
      title: 'grandes voitures familiales',
      description: 'Description of product 2',
      image: 'tiguan', // You should provide the actual image path here.
      mink: '/Familiale',
    ),
    CategorieVoiture(
      id: 8,
      title: 'voiture de sport',
      description: 'Description of product 2',
      image: 'A7', // You should provide the actual image path here.
      mink: '/Sport',
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
      Navigator.pushNamed(context, '/CategorieListVoitures');
      return true;
    },
    child :Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Catégorie"),
      ),
      body: ListView(
        children: categorieVoitures.map((categorieVoiture) => InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/ListsVoiture', arguments: {
              'catigoree':categorieVoiture.title
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
                    "assets/Images/${categorieVoiture.image}.png",
                  ),
                  Text(
                    categorieVoiture.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(categorieVoiture.description),
                ],
              ),
            ),
          ),
        ),
        ).toList(),
      ),
      bottomNavigationBar:  ClientButtonNavBar(selectedIndex: 0),
      )
    );
  }
}
