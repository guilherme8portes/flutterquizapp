import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class LessonsResultsChina extends StatefulWidget {
  const LessonsResultsChina({Key? key}) : super(key: key);

  @override
  State<LessonsResultsChina> createState() => _LessonsResultsChinaState();
}

class _LessonsResultsChinaState extends State<LessonsResultsChina> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 190.0, bottom: 35.0),
                  child: Image.asset('images/book.png', height: 150,),  // Adiciona a imagem acima do texto.
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),
                  child: Center(child: Text('Parabens, você concluiu o Quiz China!',
                      style: GoogleFonts.josefinSans(
                          color: Colors.blueGrey.shade800,
                          fontSize: 20,
                          decoration: TextDecoration.none
                      )
                  )
                  ),
                ),
                Padding(

                  padding: const EdgeInsets.only(top: 40.0, bottom: 1.0),//
                  child: //Icon(_feedbackIcon, color: _feedbackIconColor, size: _feedbackIconSize,),
                  Center(child: Text('Sua pontuação total agora é:', style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade800),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      return Text('$score', style: TextStyle(fontSize: 30,color: Colors.blueGrey.shade800));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed:  () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Voltar ao menu',
                      style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          decoration: TextDecoration.none
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Define o raio das bordas arredondadas
                      ),
                      minimumSize: Size(20, 25), // Ajuste o tamanho mínimo do botão aqui (largura x altura)
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
