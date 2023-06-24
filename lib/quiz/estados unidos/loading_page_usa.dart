import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/quiz/brasil/quiz_brasil_1.dart';
import 'package:untitled2/quiz/estados%20unidos/quiz_usa_1.dart';
import '../0firestore/firestore_services.dart';

class LoadingPageusa extends StatelessWidget {
  Future<void> setupQuiz(BuildContext context, String userId) async {
    // Obtenha a referência ao FirestoreService
    FirestoreService firestoreService = Provider.of<FirestoreService>(context, listen: false);

    // Chame a função que configura as perguntas do quiz para o usuário
    await firestoreService.setupQuizQuestions(userId, "usaQuiz");

    // Após a configuração das perguntas, navegue para a primeira página do quiz
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => QuizUsa1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final user = snapshot.data;
          if (user == null) {
            // Aqui você pode lidar com a situação quando o userId é nulo.
            // Por exemplo, você pode mostrar um erro ao usuário ou tentar fazer o login novamente.
            print('Erro: userId é nulo');
            return Scaffold(
              body: Center(
                child: Text('Erro: userId é nulo'),
              ),
            );
          } else {
            Future.delayed(Duration.zero, () async {
              try {
                await setupQuiz(context, user.uid);
              } catch (e) {
                print('Erro na chamada setupQuiz: $e');
              }
            });
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
      },
    );
  }
}