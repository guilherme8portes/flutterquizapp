import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/homepage.dart';
import 'login_page.dart';

/*
A classe LandingPage é uma página de destino sem estado que controla a navegação inicial com base no estado de autenticação do usuário.
Ela utiliza StreamBuilder para escutar as alterações no estado de autenticação fornecidas pelo método authStateChanges() do FirebaseAuth.
Se o usuário estiver autenticado, o aplicativo navega para a Homepage. Se o usuário não estiver autenticado,
o aplicativo navega para a LoginPage. Enquanto o estado de autenticação está sendo verificado,
é mostrado um spinner de carregamento na tela."
 */

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // Usuário não logado, vá para a página de login
            return LoginPage(); // Sua página de login aqui
          }
          // Usuário logado, vá para a página inicial
          return Homepage(); // Sua página inicial aqui
        } else {
          // Enquanto a conexão é estabelecida, mostre um spinner de carregamento
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
