import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService extends ChangeNotifier {
  String? userId;

  UserService() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      this.userId = user?.uid;
      notifyListeners();// Informa aos ouvintes que o userId mudou
      print('UserID atualizado: $userId'); // Imprime o ID do usuário sempre que ele muda
    });
  }
}

class FirestoreService {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<void> incrementScore(String userId) async {
    DocumentSnapshot doc = await _users.doc(userId).get();
    int score = doc['pontuação'] ?? 0;
    await _users.doc(userId).update({
      'pontuação': score + 1
    });
  }

  Future<bool> isQuestionAnswered(String userId, String quizName, String question) async {
    DocumentSnapshot doc = await _users.doc(userId).get();
    // Nós não estamos mais procurando por 'answeredQuizzes', então vamos direto para quizName
    Map<String, dynamic> quizMap = (doc.data() as Map<String, dynamic>)[quizName];
    // Agora, retorne se a pergunta já foi respondida ou não
    return quizMap[question] ?? false;
  }

  Future<void> markQuestionAsAnswered(String userId, String quizName, String question) async {
    // Atualize diretamente a pergunta do quiz, sem a necessidade de 'answeredQuizzes'
    await _users.doc(userId).update({
      '$quizName.$question': true
    });
  }

  Future<void> setupQuizQuestions(String userId, String quizName) async {
    // Primeiro, obtenha o documento do usuário
    DocumentSnapshot userDoc = await _users.doc(userId).get();

    // Se o documento do usuário já contém o mapa para o quiz especificado, retorne e não faça nada
    if (userDoc.exists && (userDoc.data() as Map<String, dynamic>)[quizName] != null) {
      return;
    }

    // Defina o mapa com as perguntas do quiz aqui com base no quizName...
    Map<String, bool>? quizQuestions;
    if (quizName == "brasilQuiz") {
      quizQuestions = {
        "Qual a Capital do Brasil?": false,
        "Qual a maior cidade do Brasil?": false,
        'Qual a empresa mais valiosa do Brasil?':false,
        'Qual a população do Brasil?':false,
        'Qual o PIB do Brasil?':false,
      };
    } else if (quizName == "usaQuiz") {
      quizQuestions = {
        "Qual a Capital dos Estados Unidos?": false,
        "Qual a maior cidade dos Estados Unidos?": false,
        'Qual a empresa mais valiosa dos Estados Unidos?': false,
        'Qual a população dos Estados Unidos?': false,
        'Qual o PIB dos Estados Unidos?': false,
      };
    }else if (quizName == "françaQuiz") {
      quizQuestions = {
        "Qual a Capital da França?": false,
        "Qual a maior cidade da França?": false,
        'Qual a empresa mais valiosa da França?': false,
        'Qual a população da França?': false,
        'Qual o PIB da França?': false,
      };
    }
    else if (quizName == "japaoQuiz") {
      quizQuestions = {
        "Qual a Capital do Japão?": false,
        "Qual a maior cidade do Japão?": false,
        'Qual a empresa mais valiosa do Japão?': false,
        'Qual a população do Japão?': false,
        'Qual o PIB do Japão?': false,
      };
    }
    else if (quizName == "chinaQuiz") {
      quizQuestions = {
        "Qual a Capital da China?": false,
        "Qual a maior cidade da China?": false,
        'Qual a empresa mais valiosa da China?': false,
        'Qual a população da China?': false,
        'Qual o PIB da China?': false,
      };
    }
    else if (quizName == "egitoQuiz") {
      quizQuestions = {
        "Qual a Capital do Egito?": false,
        "Qual a maior cidade do Egito?": false,
        'Qual a empresa mais valiosa do Egito?': false,
        'Qual a população do Egito?': false,
        'Qual o PIB do Egito?': false,
      };
    }

    // Se chegou até aqui, então é seguro criar ou atualizar o mapa do quiz
    if (quizQuestions != null) {
      await _users.doc(userId).set({
        quizName: quizQuestions,
      }, SetOptions(merge: true));
    }
  }
}

