import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:test_firebase/Commonpes/ButtonNavBar.dart';




class Remerciements extends StatefulWidget {
  const Remerciements({Key? key}) : super(key: key);

  @override
  State<Remerciements> createState() => _RemerciementsState();
}

class _RemerciementsState extends State<Remerciements> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          '/CategorieListVoitures',
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Remerciements"),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            color: Colors.white,
            elevation: 5, //
            child: Center(
              child: Text(
                "Cher(e) ,\n "
                    "Nous tenons à exprimer notre sincère gratitude pour votre intérêt pour nos services et pour nous avoir choisis pour vos besoins. Votre confiance en nous signifie beaucoup, et nous sommes ravis que votre demande ait été approuvée.\n"
                    " Votre demande a passé avec succès notre examen initial, et nous sommes enthousiastes à l'idée de continuer avec vous. Pour finaliser votre paiement et achever le processus, veuillez vous attendre à recevoir un e-mail ou un appel téléphonique de notre équipe dans les prochaines [mentionnez la période, par exemple, 24 heures]. Nous vous fournirons tous les détails nécessaires et les orientations pour effectuer votre paiement de manière pratique.\n"
                    "Si vous avez des questions ou avez besoin d'une assistance immédiate, n'hésitez pas à nous contacter à [fournir une adresse e-mail de contact] ou au [fournir un numéro de téléphone de contact]. Nous sommes là pour vous aider à chaque étape du processus.\nEncore une fois, merci de nous avoir choisis. Nous sommes impatients de vous servir et de veiller à ce que votre expérience avec nous soit exceptionnelle à tous égards.\n "
                    "Cordialement"
                    "N'hésitez pas à personnaliser le message avec des détails spécifiques tels que le nom du client, les coordonnées de votre entreprise et toute information pertinente concernant le processus de paiement.,",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        bottomNavigationBar:ButtonNavBar(selectedIndex: 0),
        ),
    );
  }
}
