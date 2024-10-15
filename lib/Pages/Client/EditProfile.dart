import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:test_firebase/Classes/Client.dart';
import 'package:test_firebase/Commonpes/ClientButtonNavBar.dart';
import '../../main.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String id = '';
  TextEditingController _nomprenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mot_de_passe = TextEditingController();
  TextEditingController _nmot_de_passe = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _cmot_de_passe = TextEditingController();
  late List<Client> _Client=[];
  late String nomprenom = '';
  late String email = '';

  Future<void> getId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      setState(() {
        id = prefs.getString('id')!;
      });
      getClient();
    }
    else{
      Navigator.pushNamed(context, '/login');
    }
  }

  Future<void> getClient() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(id)
          .get();

      if (documentSnapshot.exists) {
        Client client = Client.fromJson(documentSnapshot.data()!);
        setState(() {
          _Client.add(client);
        });
        setState(() {
          _nomprenom.text= _Client!.first.nom;
          _email.text= _Client!.first.email;
          _telephone.text=_Client!.first.telephone;
        });
      } else {
      }
    } catch (e) {

    }

  }

  Future<void> _save(String nomprenom, String email, String telephone) async {

  }

  void _Deconnexion()  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Confirmation de déconnexion"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Êtes-vous sûr de vouloir vous déconnecter ?",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
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
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('id');
                    Navigator.pushNamed(context,'/CategorieListVoitures');
                  },
                  child: Text("Déconnexion"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getId();
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(
              context,
              '/CategorieDeListVoitures'
          );
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.grey[900],
            appBar: AppBar(
                title:Text("Modifie Profile"),
                    backgroundColor: Colors.red,
            ),
            body: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: _Client != null
                  ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/Images/user.jpg',
                              ),
                              radius: 50,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 90,
                        color: Colors.grey[800],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              controller: _nomprenom,
                              decoration: InputDecoration(
                                labelText: "Nom",
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _email,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: _telephone,
                              decoration: InputDecoration(
                                labelText: "Telehone",
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _save(
                                    _nomprenom.text,
                                    _email.text,
                                    _telephone.text,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ), // Background color
                                ),
                                child: Text("Modifier"),
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _Deconnexion();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                      ), // Background color
                                    ),
                                    child: Text("Déconnexion"))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar:ClientButtonNavBar(selectedIndex:2)),
      );
    }
  }
