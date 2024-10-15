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

class InserPiece extends StatefulWidget {
  const InserPiece({Key? key}) : super(key: key);

  @override
  State<InserPiece> createState() => _InserPieceState();
}

class _InserPieceState extends State<InserPiece> {
  TextEditingController _ref = TextEditingController();
  TextEditingController _dureeV = TextEditingController();
  TextEditingController _etat = TextEditingController();
  TextEditingController _matiereF = TextEditingController();
  TextEditingController _nom = TextEditingController();
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
    Reference ref =_storage.ref().child("Piece/$_catigorie/$imageName");
    UploadTask uploadTask = ref.putData(_image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl=  await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
    Future<void> Inserpiece() async {
      String imageUrl = await uploadImage();
      DateTime dateTime = DateTime.parse(_date.text);
      Timestamp _dateF= Timestamp.fromDate(dateTime);
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        Map<String, dynamic> data = {
          'ref': _ref.text,
          'dureeV': _dureeV.text,
          'etat': _etat.text,
          'matiereF': _matiereF.text,
          'nom': _nom.text,
          'dateF': _dateF,
          'prix':_prix.text,
          'imageUrl':imageUrl,
          'id_user': id,
        };
        await firestore.collection(_catigorie).add(data);
        Navigator.pushNamed(context, '/ListsPiece', arguments: {
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
              Navigator.pushNamed(context, '/ListsPiece', arguments: {
                'catigoree':_catigorie
              });
          return true;
        },
        child : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text('Insertion de Piece'),
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nom,
                  decoration: InputDecoration(
                    labelText: 'Nom de Piece',
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
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _dureeV,
                  decoration: InputDecoration(
                    labelText: 'duree de vie',
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
              Container(
                // width: 150,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _etat,
                  decoration: InputDecoration(
                    labelText: 'Etat',
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
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _matiereF,
                  decoration: InputDecoration(
                    labelText: 'Matière de Fabrication',
                    // errorText: 'Error message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: Icon(Icons.settings),
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
                  controller: _ref,
                  decoration: InputDecoration(
                    labelText: 'Référence de Pièce',
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
                  child: TextField(
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
                          if (pickedTime != null) {
                            DateTime formattedDate = DateTime(
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
                          child: Text("photo de Piece",
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
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  Inserpiece();
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
          bottomNavigationBar: ClientButtonNavBar(selectedIndex: 1),
          )
        );
      }
    }