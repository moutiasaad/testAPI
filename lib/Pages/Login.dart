import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_firebase/Classes/Piece.dart';
import 'package:test_firebase/Classes/Voiture.dart';
import 'package:firebase_messaging/firebase_messaging.dart';  // Make sure this line is added



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mot_de_passe = TextEditingController();
  late String type="login";
  late String type_demande="";
  late Voiture? voiture;
  late Piece? piece;
  late String id;
  String token ="";
  final _firebaseMessaging= FirebaseMessaging.instance;

  void Logins(String email, String mot_de_passe, BuildContext context) async {
    try {
      var user = await auth.signInWithEmailAndPassword(email: email, password: mot_de_passe);
      if (user != null) {
        // Fetch the token asynchronously first
        String fetchedToken = await _firebaseMessaging.getToken() ?? '';

        // Now update the state synchronously within setState
        setState(() {
          token = fetchedToken;
          id = user.user!.uid;
        });

        // Update Firestore with the new FCM token
        FirebaseFirestore.instance.collection('user').doc(user.user!.uid).update({
          'fcmToken': token,
        });

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('id', id);

        // Navigation logic
        if (type != "login") {
          if (type == "voiture") {
            DateTime dateTime = DateTime.now();
            Timestamp _date = Timestamp.fromDate(dateTime);
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            Map<String, dynamic> DemandeData = {
              'type': type_demande,
              'date': _date,
              'user_id': id,
              'modele': voiture!.modele,
              'numeroSeries': voiture!.numeroSerie,
              'prix': voiture!.prix
            };
            await firestore.collection("DemandeVoiture").add(DemandeData);
            Navigator.pushNamed(context, '/Remerciements');
          } else if (type == "piece") {
            DateTime dateTime = DateTime.now();
            Timestamp _date = Timestamp.fromDate(dateTime);
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            Map<String, dynamic> DemandeData = {
              'type': type_demande,
              'date': _date,
              'user_id': id,
              'nom': piece!.nom,
              'ref': piece!.ref,
              'prix': piece!.prix
            };
            await firestore.collection("DemandePiece").add(DemandeData);
            Navigator.pushNamed(context, '/Remerciements');
          }
        } else {
          Navigator.pushNamed(context, '/CategorieDeListVoitures');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Email ou mot de passe incorrect",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // initNotifications();  // Proper initialization in initState()
  }

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
        onWillPop: () async {
          if(type=='login'){
            Navigator.pushNamed(context, '/CategorieListVoitures');
          }
          return false;
        },
        child :Scaffold(
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(height: 50.0),
                  Image.asset(
                    'assets/Images/logo.png',
                    width: 200,
                    height: 200,
                  ),
                  // SizedBox(height: 32.0),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    obscureText: true,
                    controller: _mot_de_passe,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.key),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Logins(_email.text, _mot_de_passe.text, context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ), // Background color
                    ),
                    child: const Text('Login'),
                  ),
                  SizedBox(height: 32.0),
                  Text("Vous n’avez pas de compte ?"),
                  TextButton(
                    onPressed: () {
                      if(type!="login"){
                        if(type=="voiture"){
                          Navigator.pushNamed(context, '/Inscription',arguments: {
                            'type':"voiture",
                            'voiture':voiture
                          });
                        }
                        else if(type=="piece"){
                          Navigator.pushNamed(context, '/Inscription',arguments: {
                            'type':"piece",
                            'piece':piece
                          });
                        }
                      }
                      else{
                        Navigator.pushNamed(context, '/Inscription',);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.blue[700],

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ), // Background color
                    ),
                    child: const Text(
                      "S'inscrire",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(12, 30, 196, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
