import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';


class PaginaDeConfiguracoes extends StatefulWidget {
  const PaginaDeConfiguracoes({Key? key}) : super(key: key);

  @override
  State<PaginaDeConfiguracoes> createState() => _PaginaDeConfiguracoesState();
}
class _PaginaDeConfiguracoesState extends State<PaginaDeConfiguracoes> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut() async {
    await _auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.7),
        elevation: 0,
        title: Text( "Configuraçôes",style: GoogleFonts.inter(color: Colors.white,fontSize: 23),),
        centerTitle: true,
      ),
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
                  padding: const EdgeInsets.only(top: 190.0, bottom: 35.0),
                  child: SizedBox(
                    width: 150, // Defina a largura do Rive aqui
                    height: 150, // Defina a altura do Rive aqui
                    child: RiveAnimation.asset(
                      'animations/engrenagemrive.riv',
                    ),
                  ), // Adiciona a imagem acima do texto.
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 1.0),//
                  child: //Icon(_feedbackIcon, color: _feedbackIconColor, size: _feedbackIconSize,),
                  Center(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Define o raio das bordas arredondadas
                      ),
                    ),
                    onPressed: _signOut,
                    child: Text('Logout'),
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
}

