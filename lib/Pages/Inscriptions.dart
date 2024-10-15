
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:test_firebase/Classes/Piece.dart';
import 'package:test_firebase/Classes/Voiture.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Inscription extends StatefulWidget {
  const Inscription({Key? key}) : super(key: key);

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mot_de_passe = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _cmot_de_passe = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _Adress = TextEditingController();
  TextEditingController _cin = TextEditingController();
  late String type="login";
  late Voiture? voiture;
  late Piece? piece;
  late String id;
  bool _isLoading = false; // Loading indicator

  Future<void> inscriptions() async {
    try {
      // Create user with email and password in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _mot_de_passe.text,
      );

      // Prepare data to store in Firestore
      DateTime dateTime = DateTime.parse(_date.text);
      Timestamp _dateNaissance = Timestamp.fromDate(dateTime);
      Map<String, dynamic> userData = {
        'nom': _nom.text,
        'prenom': _prenom.text,
        'cin': _cin.text,
        'Adress': _Adress.text,
        'dateNaissance': _dateNaissance,
        'email': _email.text,
        'telephone': _telephone.text,
      };

      // Store user data in Firestore under 'user' collection
      FirebaseFirestore.instance.collection('user').doc(userCredential.user!.uid).set(userData).then((_) async {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          id = userCredential.user!.uid; // Use UID from Auth as Firestore document ID
        });
        prefs.setString('id', id);

        // Continue with the rest of your logic
        if (type != "login") {
          if (type == "voiture") {
            try {
              Timestamp _date = Timestamp.fromDate(DateTime.now());
              Map<String, dynamic> DemandeData = {
                'type': type,
                'date': _date,
                'user_id': id,
                'modele': voiture!.modele,
                'numeroSeries': voiture!.numeroSerie,
                'prix': voiture!.prix,
              };
              await FirebaseFirestore.instance.collection("DemandeVoiture").add(DemandeData);
              Navigator.pushNamed(context, '/Remerciements');
            } catch (e) {
              Fluttertoast.showToast(
                  msg: e.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          } else if (type == "piece") {
            try {
              Timestamp _date = Timestamp.fromDate(DateTime.now());
              Map<String, dynamic> DemandeData = {
                'type': type,
                'date': _date,
                'user_id': id,
                'nom': piece!.nom,
                'ref': piece!.ref,
                'prix': piece!.prix,
              };
              await FirebaseFirestore.instance.collection("DemandePiece").add(DemandeData);
              Navigator.pushNamed(context, '/Remerciements');
            } catch (e) {
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
        } else {
          Navigator.pushNamed(context, '/CategorieDeListVoitures');
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _addDemande(String userId) async {
    DateTime dateTime = DateTime.now();
    Timestamp _date = Timestamp.fromDate(dateTime);

    Map<String, dynamic> demandeData = {
      'type': type,
      'date': _date,
      'user_id': userId,
    };

    if (type == "voiture") {
      demandeData['modele'] = voiture!.modele;
      demandeData['numeroSeries'] = voiture!.numeroSerie;
      demandeData['prix'] = voiture!.prix;
    } else if (type == "piece") {
      demandeData['nom'] = piece!.nom;
      demandeData['ref'] = piece!.ref;
      demandeData['prix'] = piece!.prix;
    }

    try {
      await FirebaseFirestore.instance.collection("Demandes").add(demandeData);
      Navigator.pushNamed(context, '/Remerciements');
    } catch (e) {
      Fluttertoast.showToast(msg: "Error adding demande: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings?.arguments as Map<String, dynamic>?;
    if(arguments != null){
      setState(() {
        type= arguments!['type'] as String;
      });
      if(type=="voiture"){
        setState(() {
          voiture= arguments['voiture']  as Voiture;
        });
      }
      else if (type=="piece"){
        setState(() {
          piece= arguments['piece'] as Piece;
        });
      }
    }
    return WillPopScope(
        onWillPop: () async{
      Navigator.pushNamed(context, '/login');
      return true;
    },
    child :  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: Text('Inscriptions'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nom,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                Container(
                  // width: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _prenom,
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      // errorText: 'Error message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  // width: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _cin,
                    decoration: InputDecoration(
                      labelText: "Numéro de carte d'identité",
                      // errorText: 'Error message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  // width: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _Adress,
                    decoration: InputDecoration(
                      labelText: 'Adresse',
                      // errorText: 'Error message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.email),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  // width: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _email,
                    // initialValue: 'Languer',
                    decoration: InputDecoration(
                      labelText: 'Email',
                      // errorText: 'Error message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.email),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                Card(
                    margin: EdgeInsets.all(16),
                    child:TextField(
                        controller: _date,
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "Date",
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {DateTime formattedDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            setState(() {
                              String formattedDateString =
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(formattedDate);
                              _date.text = formattedDateString;
                            });
                            } else {}
                          }
                        }
                    )
                ),
                Container(
                  // width: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    controller: _mot_de_passe,
                    // initialValue: 'Hauteur',
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      // errorText: 'Error message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.key),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                Container(
                  // width: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    controller: _cmot_de_passe,
                    decoration: InputDecoration(
                      labelText: 'Confirmer  mot de passe',
                      // errorText: 'Error message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.key),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                Container(
                  // width: 300,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _telephone,
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      // errorText: 'Error message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.phone),
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_mot_de_passe.text != _cmot_de_passe.text) {
                      Fluttertoast.showToast(msg: "Passwords do not match.");
                      return;
                    }
                    await inscriptions();
                  },
                  child: _isLoading // Show loading indicator on button
                      ? CircularProgressIndicator()
                      : const Text(
                    'Inscription',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(59, 62, 220, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ), // Background color
                  ),
                )
              ],
            ),
          ),
        ),
      ));
  }
}
