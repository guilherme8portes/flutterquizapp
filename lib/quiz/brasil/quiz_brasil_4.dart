import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/quiz/brasil/quiz_brasil_2.dart';
import 'package:untitled2/quiz/brasil/quiz_brasil_5.dart';
import '../../funcionalidades/exitalert.dart';
import '../0firestore/firestore_services.dart';

class QuizBrasil4 extends StatefulWidget {


  @override
  _QuizBrasil4State createState() => _QuizBrasil4State();
}
class _QuizBrasil4State extends State<QuizBrasil4> {
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
    if (await firestoreService.isQuestionAnswered(userId, "brasilQuiz", "Qual a empresa mais valiosa do Brasil?")) {
      setState(() {
        _feedbackMessage = 'Você já respondeu essa pergunta corretamente antes!';
        Future.delayed(const Duration(seconds: 3), () async{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuizBrasil5()),
          );
        }
        );
      });
      return;
    }

    // Transforma a resposta em minúsculas antes de comparar
    if (_userAnswer.trim().toLowerCase() == 'petrobras') {
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
      firestoreService.markQuestionAsAnswered(userId, "brasilQuiz", "Qual a empresa mais valiosa do Brasil?");

      Future.delayed(const Duration(seconds: 3), () async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizBrasil5()),
        );
      }
      );
    } else {
      setState(() {
        _feedbackMessage = 'Resposta correta: Petrobras';
        _feedbackIcon = Icons.close;
        _feedbackIconColor = Colors.red;
        _feedbackIconSize = 30.0;
      });

      await _playWrongAnswerAudio();
      Future.delayed(const Duration(seconds: 3), () async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizBrasil5()),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                  padding: EdgeInsets.only(top: screenHeight * 0.18, bottom: screenHeight * 0.05),
                  child: Image.asset('images/circularbrasil.png', height: 150,),  // Adiciona a imagem acima do texto.
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.05, bottom: screenHeight * 0.01),
                  child: Center(child: Text('Qual empresa mais valiosa do Brasil?',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none
                      )
                  )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: screenHeight * 0.01),//
                  child: //Icon(_feedbackIcon, color: _feedbackIconColor, size: _feedbackIconSize,),
                  Center(child: Text(_feedbackMessage, style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      decoration: TextDecoration.none
                  ),)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02, bottom: screenHeight * 0.02),//symmetric(vertical: 25.0),
                  child: _buildTextButton(_userAnswer),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: screenWidth * 0.05,
                  runSpacing: screenWidth * 0.05,
                  children: [
                    ...[
                      'Vale',
                      'Banco do Brasil',
                      'Petrobras',
                      'Bradesco'
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
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 20,
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
                        child: Icon(Icons.backspace, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  child: ElevatedButton(
                    onPressed: _onVerifyAnswer,
                    child: Text(
                      'Verificar',
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
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.04,
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
