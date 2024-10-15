import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:test_firebase/Commonpes/ClientButtonNavBar.dart';
import 'package:test_firebase/main.dart';
class InseriVoiture extends StatefulWidget {
  const InseriVoiture({Key? key}) : super(key: key);

  @override
  State<InseriVoiture> createState() => _InseriVoitureState();
}

class _InseriVoitureState extends State<InseriVoiture> {
  TextEditingController _numeroSeries = TextEditingController();
  TextEditingController _marque = TextEditingController();
  TextEditingController _modele = TextEditingController();
  TextEditingController _couleur = TextEditingController();
  TextEditingController _typeBoite = TextEditingController();
  TextEditingController _kilometrage = TextEditingController();
  TextEditingController _puissenseFiscale = TextEditingController();
  TextEditingController _typeCarrosserie = TextEditingController();
  TextEditingController _carburant = TextEditingController();
  TextEditingController _cylindree = TextEditingController();
  TextEditingController _prix = TextEditingController();
  TextEditingController _date = TextEditingController();
  late String? id;
  String _catigorie ="";
  late String Image_Path = '';
  late CameraController _controller;
  late XFile? image;
  Camera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("acces was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
    setState(() async {
      final image =
      (await ImagePicker().pickImage(source: ImageSource.camera)) as XFile?;
    });
    if (image != null) {
      return image!.path;
    }
  }
  Gallery() async {
    image =
    (await ImagePicker().pickImage(source: ImageSource.gallery)) as XFile?;
    if (image != null) {
      return image!.path;
    }
  }

  Future<String> uploadImage() async{
    final FirebaseStorage _storage = FirebaseStorage.instance;
    File file = File(image!.path);
    Uint8List _image = await file.readAsBytes();
    String imageName = path.basename(Image_Path);
    Reference ref =_storage.ref().child("Voiture/$_catigorie/$imageName");
    UploadTask uploadTask = ref.putData(_image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl=  await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<void> Inservoiture() async {
    DateTime dateTime = DateTime.parse(_date.text);
    Timestamp _anneeProduction= Timestamp.fromDate(dateTime);
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String imageUrl = await uploadImage();
      Map<String, dynamic> data = {
        'numeroSeries': _numeroSeries.text,
        'marque': _marque.text,
        'modele': _modele.text,
        'couleur': _couleur.text,
        'typeBoite': _typeBoite.text,
        'kilometrage': _kilometrage.text,
        'puissenseFiscale': _puissenseFiscale.text,
        'typeCarrosserie': _typeCarrosserie.text,
        'carburant': _carburant.text,
        'cylindree': _cylindree.text,
        'prix':_prix.text,
        'anneeProduction': _anneeProduction,
        'imageUrl': imageUrl,
        'id_user': id,
      };
      await firestore.collection(_catigorie).add(data);
      Fluttertoast.showToast(
          msg: "Insertion succes.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushNamed(context, '/ListsVoiture', arguments: {
        'catigoree':_catigorie
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error adding data to Firestore: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
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
    final arguments =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    setState(() {
      _catigorie = arguments['catigoree'] as String;
    });
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushNamed(context, '/ListsVoiture', arguments: {
        'catigoree':_catigorie
      });
      return true;
    },
    child :Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Insertion de Voiture'),
      ),
      body: ListView(
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _marque,
                  decoration: InputDecoration(
                    labelText: 'Marque',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.abc),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _modele,
                  decoration: InputDecoration(
                    labelText: 'Modele',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.abc),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _numeroSeries,
                  decoration: InputDecoration(
                    labelText: 'Numero Series',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.numbers),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _couleur,
                  decoration: InputDecoration(
                    labelText: 'Couleur',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.color_lens),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _typeBoite,
                  decoration: InputDecoration(
                    labelText: 'Type de Boite',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.border_inner_outlined),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _kilometrage,
                  decoration: InputDecoration(
                    labelText: 'Kilometrage',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.numbers),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
            SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _puissenseFiscale,
                  decoration: InputDecoration(
                    labelText: 'Puissense Fiscale',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.numbers),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _typeCarrosserie,
                  decoration: InputDecoration(
                    labelText: 'Type Carrosserie',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.abc),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                // width: 300,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _carburant,
                  decoration: InputDecoration(
                    labelText: 'Carburant',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.abc),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _cylindree,
                  decoration: InputDecoration(
                    labelText: 'Cylindree',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.abc),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _prix,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Prix',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.monetization_on),
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
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () async {
                    Image_Path = await Gallery();
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text("photo de Voiture",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () async {
                            Image_Path = await Camera();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Inservoiture();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ), // Background color
                ),
                child: const Text(
                  'Inséré',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
      bottomNavigationBar: ClientButtonNavBar(selectedIndex: 0),
    )
    );
  }
}
