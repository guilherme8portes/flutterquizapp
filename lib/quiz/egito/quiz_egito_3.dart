import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/quiz/brasil/quiz_brasil_2.dart';
import 'package:untitled2/quiz/egito/quiz_egito_4.dart';
import '../../funcionalidades/exitalert.dart';
import '../0firestore/firestore_services.dart';

class QuizEgito3 extends StatefulWidget {


  @override
  _QuizEgito3State createState() => _QuizEgito3State();
}
class _QuizEgito3State extends State<QuizEgito3> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;
  final FirestoreService _firestoreService = FirestoreService();
  String _userAnswer = '';
  String _feedbackMessage = '';
  IconData? _feedbackIcon;
  Color? _feedbackIconColor;
  double? _feedbackIconSize;
  bool _isCorrectAnswer = false;
  late AudioPlayer singleShotPlayer;

  @override
  void initState() {
    super.initState();
    singleShotPlayer = AudioPlayer();
    userId = _auth.currentUser?.uid ?? '';
  }

  Future<void> _playCorrectAnswerAudio() async {
    try {
      await singleShotPlayer.setAsset('audios/rightsound.mp3');
      singleShotPlayer.play();
      // Aguarda o término do primeiro áudio
      await singleShotPlayer.positionStream.firstWhere((position) => position == singleShotPlayer.duration);
    } catch (e) {
      // catch error
    }
  }

  Future<void> _playWrongAnswerAudio() async {
    try {
      await singleShotPlayer.setAsset('audios/errorsound.mp3'); // substitua pelo caminho do seu áudio de resposta errada
      singleShotPlayer.play();
    } catch (e) {
      // catch error
    }
  }

  void _onLetterSelected(String word) {
    setState(() {
      _userAnswer += ' ' + word; // adiciona um espaço antes de cada palavra
    });
  }

  void _onVerifyAnswer() async {
    // Obtenha a referência ao FirestoreService
    FirestoreService firestoreService = Provider.of<FirestoreService>(context, listen: false);

    // Verifique se a questão já foi respondida
    if (await firestoreService.isQuestionAnswered(userId, "egitoQuiz", "Qual a empresa mais valiosa do Egito?")) {
      setState(() {
        _feedbackMessage = 'Você já respondeu essa pergunta corretamente antes!';
        Future.delayed(const Duration(seconds: 3), () async{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuizEgito4()),
          );
        }
        );
      });
      return;
    }

    // Transforma a resposta em minúsculas antes de comparar
    if (_userAnswer.trim().toLowerCase() == 'orascom') {
      setState(() {
        _feedbackMessage = 'Muito bem!';
        _isCorrectAnswer = true;
        _feedbackIcon = Icons.check;
        _feedbackIconColor = Colors.green;
        _feedbackIconSize = 30.0;
      });

      await _playCorrectAnswerAudio();

      // Incrementa a pontuação do usuário
      firestoreService.incrementScore(userId);//erro 1

      // Marque a questão como respondida
      firestoreService.markQuestionAsAnswered(userId, "egitoQuiz", "Qual a empresa mais valiosa do Egito?");

      Future.delayed(const Duration(seconds: 3), () async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizEgito4()),
        );
      }
      );
    } else {
      setState(() {
        _feedbackMessage = 'Resposta correta: Orascom';
        _feedbackIcon = Icons.close;
        _feedbackIconColor = Colors.red;
        _feedbackIconSize = 30.0;
      });

      await _playWrongAnswerAudio();
      Future.delayed(const Duration(seconds: 3), () async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizEgito4()),
        );
      }
      );
    }
  }



  Widget _buildTextButton(String text) {//caixa onde resposta é digitada
    return OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade400.withOpacity(0.2),
        side: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(text, style: GoogleFonts.josefinSans(
          color: Colors.white,
          fontSize: 24,
          decoration: TextDecoration.none
      ),),
    );
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
                  child: Image.asset('images/circularegito.png', height: 150,),  // Adiciona a imagem acima do texto.
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 1.0),
                  child: Center(child: Text('Qual a empresa mais valiosa do Egito?',
                      style: GoogleFonts.josefinSans(
                          color: Colors.blueGrey.shade800,
                          fontSize: 20,
                          decoration: TextDecoration.none
                      )
                  )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),//
                  child: //Icon(_feedbackIcon, color: _feedbackIconColor, size: _feedbackIconSize,),
                  Center(child: Text(_feedbackMessage, style: TextStyle(fontSize: 15, color: Colors.blueGrey.shade800),)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),//symmetric(vertical: 25.0),
                  child: _buildTextButton(_userAnswer),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 15.0,
                  runSpacing: 15.0,
                  children: [
                    ...[
                      'Orascom',
                      'EgyptAir',
                      'Corona',
                      'Nilesat'
                    ].map(
                          (word) => GestureDetector(
                        onTap: () => _onLetterSelected(word),
                        child: Container(
                          padding: EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            color: Colors.white12, //cor das palavras clicaveis
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            word,
                            style: GoogleFonts.josefinSans(
                                color: Colors.blueGrey.shade800,
                                fontSize: 23,
                                decoration: TextDecoration.none
                            ),
                          ),
                        ),
                      ),
                    ).toList(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_userAnswer.isNotEmpty) {
                            _userAnswer = _userAnswer.substring(0, _userAnswer.length - 1);
                          }
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.backspace, color: Colors.blueGrey.shade800),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed: _onVerifyAnswer,
                    child: Text(
                      'Verificar',
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
          Positioned(
            top: 50.0,
            left: 20.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.transparent,
              ),
              child:  Icon(Icons.close, color: Colors.white),
              onPressed: () async {
                final shouldExit = await Exitalert(context,
                    title: "Sair",
                    content: "Realmente deseja sair? Você perdera todo o progresso da lição",
                    defaultActionText: "Sair",
                    cancelActionText: "Não sair"
                );
                if (shouldExit) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                } else {
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //backgroundPlayer.dispose();
    singleShotPlayer.dispose();
    super.dispose();
  }

}