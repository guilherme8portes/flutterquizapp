import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/quiz/brasil/loading_page.dart';

// Definição da classe ImageInfo, que será utilizada para representar
// informações associadas a uma imagem, como seu caminho (imagePath),
// um texto (text) e uma ação que será executada quando a imagem for clicada (onClick).
class ImageInfo {

  // Variável para armazenar o caminho da imagem.
  final String imagePath;

  // Variável para armazenar o texto associado à imagem.
  final String text;

  // Função que será chamada quando a imagem for clicada.
  final VoidCallback onClick;

  // Construtor da classe, que inicializa as variáveis imagePath, text e onClick.
  // A keyword 'required' indica que todos esses três parâmetros são obrigatórios
  // na criação de uma instância da classe ImageInfo.
  ImageInfo({required this.imagePath, required this.text, required this.onClick});
}

class PaginaInicial extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<ImageInfo> imageInfoList = [
      ImageInfo(
        imagePath: 'images/brasilquiz.png',
        text: 'Brasil',
        onClick: () {
          Future.delayed(const Duration(seconds: 0), () async {
            //await backgroundPlayer.stop();
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => LoadingPage(),
              ),
            );
          }
          );
        },
      ),
      ImageInfo(
        imagePath: 'images/usaquiz.png',
        text: 'Estados Unidos',
        onClick: () {

        },
      ),
      ImageInfo(
        imagePath: 'images/françaquiz.png',
        text: 'França',
        onClick: () {

        },
      ),
      // Adicione mais objetos ImageInfo para outras imagens
    ];

    List<ImageInfo> imageInfoList2 = [
      ImageInfo(
        imagePath: 'images/japaoquiz.png',
        text: 'Japão',
        onClick: () {

        },
      ),
      ImageInfo(
        imagePath: 'images/chinaquiz.png',
        text: 'China',
        onClick: () {

        },
      ),
      ImageInfo(
        imagePath: 'images/egitoquiz.png',
        text: 'Egito',
        onClick: () {

        },
      ),
      // Adicione mais objetos ImageInfo para outras imagens
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.7),//fromRGBO(0, 44, 93, 1.0).withOpacity(0.4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text( "World Quiz",
          style: GoogleFonts.inter(
              color: Colors.white,fontSize: 25
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(  // Adicionando o widget Padding
        padding: const EdgeInsets.only(top: 20.0), // Escolha o valor do padding que preferir
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('América e Europa',style: GoogleFonts.inter(fontSize: 15,color: Colors.white),),
              SizedBox(height: 20),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageInfoList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: imageInfoList[index].onClick,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                Container(
                                  height: 170,
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image: AssetImage(imageInfoList[index].imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    color: Colors.green.shade800,
                                    child: Text(
                                      imageInfoList[index].text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),  // Ajuste esse valor para o espaço desejado
                  Text('Asia e Africa',style: GoogleFonts.inter(fontSize: 17,color: Colors.white),),
                  SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageInfoList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: imageInfoList2[index].onClick,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Stack(
                                children: [
                                  Container(
                                    height: 170,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      image: DecorationImage(
                                        image: AssetImage(imageInfoList2[index].imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center, // Ajuste esta linha para mover o Container dentro da imagem.
                                    child: Container(
                                      padding: EdgeInsets.all(10), // Adicione um pouco de padding para dar espaço ao texto.
                                      color: Colors.green.shade800,
                                      child: Text(
                                        imageInfoList2[index].text,
                                        textAlign: TextAlign.center, // Centraliza o texto no Container.
                                        style: GoogleFonts.inter(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


