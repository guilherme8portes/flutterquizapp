import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class LessonsResults extends StatefulWidget {
  const LessonsResults({Key? key}) : super(key: key);

  @override
  State<LessonsResults> createState() => _LessonsResultsState();
}

class _LessonsResultsState extends State<LessonsResults> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initAudio();
  }

  Future<void> initAudio() async {
    try {
      await player.setAsset('audios/clap3.mp3'); // substitua 'my_audio_file.mp3' pelo caminho do seu arquivo de áudio
      player.play();
    } catch (e) {
      // trate a exceção aqui
      print('Error loading audio source: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children: [
      Container(
      decoration: BoxDecoration(
      color: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.7),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Padding(
    padding: EdgeInsets.only(top: screenHeight * 0.25, bottom: screenHeight * 0.05),
    child: Image.asset('images/circularbrasil.png', height: screenHeight * 0.2,),  // Adiciona a imagem acima do texto.
    ),
    Padding(
    padding: EdgeInsets.only(top: screenHeight * 0.04, bottom: screenHeight * 0.01),
    child: Center(child: Text('Parabens, você concluiu o Quiz Brasil!',
    style: GoogleFonts.inter(
    color: Colors.white,
    fontSize: screenHeight * 0.020,
    decoration: TextDecoration.none
    )
    )
    ),
    ),
    Padding(

    padding: EdgeInsets.only(top: screenHeight * 0.05, bottom: screenHeight * 0.01),//
    child: //Icon(_feedbackIcon, color: _feedbackIconColor, size: _feedbackIconSize,),
    Center(child: Text('Sua pontuação total agora é:', style: TextStyle(fontSize: screenHeight * 0.017, color: Colors.white),)),
    ),
    Padding(
    padding: EdgeInsets.all(screenHeight * 0.01),
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
    return Text('$score', style: TextStyle(fontSize: screenHeight * 0.037,color: Colors.white));
    },
    ),
    ),
    Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
    child: ElevatedButton(
    onPressed:  () {
    Navigator.pop(context);
    },
      child: Text(
        'Voltar ao menu',
        style: GoogleFonts.inter(
            color: Colors.white,
            decoration: TextDecoration.none
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Define o raio das bordas arredondadas
        ),
        minimumSize: Size(screenWidth * 0.05, screenHeight * 0.03), // Ajuste o tamanho mínimo do botão aqui (largura x altura)
      ),
    ),

    ),
    ],
    ),
      ),
          ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

