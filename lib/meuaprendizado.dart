import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'funcionalidades/score_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MeuAprendizado extends StatefulWidget {
  const MeuAprendizado({Key? key}) : super(key: key);

  @override
  State<MeuAprendizado> createState() => _MeuAprendizadoState();
}

class _MeuAprendizadoState extends State<MeuAprendizado> {
  @override
  Widget build(BuildContext context) {
    // Determinar a altura e a largura da tela
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.7),
        elevation: 0,
        title: Text("Pontuação", style: GoogleFonts.inter(color: Colors.white, fontSize: 23)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              // Usando proporção em vez de valor fixo
              padding: EdgeInsets.only(top: screenHeight * 0.25, bottom: screenHeight * 0.05),
              child: Container(
                // Usando proporção em vez de valor fixo
                height: screenHeight * 0.23,
                width: screenWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/score2.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                alignment: Alignment.center,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Ocorreu um erro');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Carregando...");
                    }

                    int score = (snapshot.data?.data() as Map<String, dynamic>)?['pontuação'] ?? 0;
                    return Text('$score', style: TextStyle(fontSize: 30, color: Colors.blueGrey.shade800));
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight * 0.01, bottom: screenHeight * 0.01),
              child: Text(
                'Pontuação total alcançável: 30 pontos',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



