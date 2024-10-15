import 'package:flutter/material.dart';
import 'package:test_firebase/Classes/Piece.dart';
import '../../Commonpes/ButtonNavBar.dart';
import '../../Commonpes/ClientButtonNavBar.dart';
class DetailsDePiece extends StatefulWidget {
  const DetailsDePiece({Key? key}) : super(key: key);

  @override
  State<DetailsDePiece> createState() => _DetailsDePieceState();
}

class _DetailsDePieceState extends State<DetailsDePiece> {
  late Piece? _piece;
  late bool _session=false;
  late String catigoree="";
  late String? id ;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _piece= arguments['piece'] as Piece;
    catigoree= arguments['catigoree'] as String;
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, '/ListsPiece',arguments: {
        'catigoree':catigoree
      });
      return true;
    },
    child : Scaffold(
      appBar: AppBar(
        title: Text('Details de Piece'),
      ),
      body:SingleChildScrollView(
        child: Card(
          child: Column(
            children: [
              Image.network(_piece!.imgeUrl),
              SizedBox(height: 10,
              ),
              Text(_piece!.nom),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Date de Fabriction:"),
                  SizedBox(width: 10,),
                  Text(_piece!.dateF.toDate().toString())
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Duree de vie:"),
                  SizedBox(width: 10,),
                  Text(_piece!.dureeV)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Etat"),
                  SizedBox(width: 10,),
                  Text(_piece!.etat)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Matier de Fabrication:"),
                  SizedBox(width: 10,),
                  Text(_piece!.matiereF)
                ],
              ),
              SizedBox(height: 8.0),
              Text(_piece!.prix.toString()+"£"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClientButtonNavBar(selectedIndex: 1,),
    ));
  }
}
