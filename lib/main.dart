import 'package:flutter/material.dart';
import 'dart:core';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_firebase/firebase_options.dart';
import 'package:test_firebase/Pages/CategoriePiece.dart';
import 'package:test_firebase/Pages/CategorieVoiture.dart';
import 'package:test_firebase/Pages/Client/CategorieDeVoiture.dart';
import 'package:test_firebase/Pages/Client/CatigorieDePiece.dart';
import 'package:test_firebase/Pages/Client/DetailsDePiece.dart';
import 'package:test_firebase/Pages/Client/DetailsDeVoiture.dart';
import 'package:test_firebase/Pages/Client/EditProfile.dart';
import 'package:test_firebase/Pages/Client/InseriPiece.dart';
import 'package:test_firebase/Pages/Client/InseriVoiture.dart';
import 'package:test_firebase/Pages/Client/ListPiece.dart';
import 'package:test_firebase/Pages/Client/ListVoiture.dart';
import 'package:test_firebase/Pages/Client/Notifications.dart';
import 'package:test_firebase/Pages/DetailsPiece.dart';
import 'package:test_firebase/Pages/DetailsVoiture.dart';
import 'package:test_firebase/Pages/Inscriptions.dart';
import 'package:test_firebase/Pages/List_de_Piece.dart';
import 'package:test_firebase/Pages/List_de_Voitures.dart';
import 'package:test_firebase/Pages/Login.dart';
import 'package:test_firebase/Pages/Remerciements.dart';

late List<CameraDescription> cameras;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

Future<void> initFirebaseMessaging() async {
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initFirebaseMessaging();
  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    initialRoute: '/CategorieListVoitures',
    routes: {
      '/login': (context) => Login(),
      '/Inscription': (context) => Inscription(),
      '/CategorieListVoitures':(context)=>CategorieListVoitures(),
      '/ListVoiture': (context) => ListVoiture(),
      '/DetailsVoiture' : (context)=>DetailsVoiture(),
      '/CategorieListPieces':(context)=>CategorieListPieces(),
      '/ListPiece':(context)=>ListPiece(),
      '/DetailsPiece':(context)=>DetailsPiece(),
      '/InseriVoiture':(context)=>InseriVoiture(),
      '/InseriPiece':(context)=>InserPiece(),
      '/ListsVoiture':(context)=>ListsVoiture(),
      '/ListsPiece':(context)=>ListsPiece(),
      '/CategorieDeListVoitures':(context)=>CategorieDeListVoitures(),
      '/CategorieDeListPieces':(context)=>CategorieDeListPieces(),
      '/DetailsDeVoiture':(context)=>DetailsDeVoiture(),
      '/DetailsDePiece':(context)=>DetailsDePiece(),
      '/EditProfile':(context)=>EditProfilePage(),
      '/Remerciements':(context)=>Remerciements(),
      '/notifications':(context)=>SendNotificationPage()
    },
  )
  );
}