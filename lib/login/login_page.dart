import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Definição da classe _LoginPageState que herda de State.
// Esta classe define o estado da nossa LoginPage.
class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
// Método assíncrono para o login com o Google.
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn
        .signIn();
    // Obtenção da autenticação do usuário do Google
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await createUserInFirestore(userCredential);
    return userCredential;
  }
// Método assíncrono para o login anônimo.
  Future<UserCredential?> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    // Criação do usuário no Firestore.
    await createUserInFirestore(userCredential);
    return userCredential;
  }
// Método assíncrono para criar o usuário no Firestore.
  Future<void> createUserInFirestore(UserCredential userCredential) async {
    // Apenas criar uma nova conta se não existir
    final usersRef = FirebaseFirestore.instance.collection('users');
    final docSnapshot = await usersRef.doc(userCredential.user!.uid).get();

    if (!docSnapshot.exists) {
      // Inicializar a pontuação do novo usuário como 0.
      usersRef
          .doc(userCredential.user!.uid)
          .set({'pontuação': 0}); // Começa a pontuação do novo usuário como 0
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.7),
        elevation: 0,
        title: Text("Bem vindo ao World Quiz!", style: TextStyle(color: Colors.white),),
          centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.7), // Cor de fundo
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 170),
                ElevatedButton(
                  onPressed: () async {
                    await signInWithGoogle();
                  },
                  child: Text(
                    'Login com Google', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    //minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.green.shade800,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await signInAnonymously();
                  },
                  child: Text(
                    'Login Anônimo', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    //minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 90,
            // Altere este valor para mover a imagem para cima ou para baixo
            child: Container(
              height: 200,
              child: Image.asset('images/earthpic.png'),
            ),
          ),
        ],
      ),
    );
  }
}



