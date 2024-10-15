import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase/Classes/Piece.dart';
import 'package:test_firebase/Commonpes/ButtonNavBar.dart';

class DetailsPiece extends StatefulWidget {
  const DetailsPiece({Key? key}) : super(key: key);

  @override
  State<DetailsPiece> createState() => _DetailsPieceState();
}

class _DetailsPieceState extends State<DetailsPiece> {
  late Piece? _piece;
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
        'type':"Piece",
        'date':_date,
        'userId':id,
        'nom':_piece!.nom,
        'ref':_piece!.ref,
        'prix':_piece!.prix
      };
      await firestore.collection("DemandePiece").add(DemandeData);
      Navigator.pushNamed(context, '/Remerciements', arguments: {
        'type':_catigoriee
      });
    }
    catch (e){
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      }
    }
  else{
    Navigator.pushNamed(context, '/login', arguments: {
      'type':"piece",
      'piece':_piece
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
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _piece= arguments['piece'] as Piece;
    _catigoriee= arguments['type'] as String;
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, '/ListsPiece', arguments: {
        'type':_catigoriee
      });
      return true;
    },
    child : Scaffold(
      appBar: AppBar(
        title: Text('Details de Piece'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
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
              ElevatedButton(
                  onPressed:  () async {
                    await PasseDemande();
                  },
                  child: Text("Payez")
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavBar(selectedIndex: 1,),
      )
    );
  }
}
