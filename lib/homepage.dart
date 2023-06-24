import 'package:flutter/material.dart';
import 'paginadeconfiguracoes.dart';
import 'meuaprendizado.dart';
import 'paginainicial.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}
// Esta é a página principal do nosso aplicativo.
class _HomepageState extends State<Homepage> {
  // Variável que mantém o índice da página atual.
  int _currentIndex = 0;
  // Lista dos widgets das páginas que podem ser exibidas.
  // Cada widget representa uma página diferente.
  final List<Widget> _pages = [
    PaginaInicial(), // Este widget representa a página inicial
    const MeuAprendizado(),
    const PaginaDeConfiguracoes(),
  ];  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Color.fromRGBO(74, 117, 75, 1.0).withOpacity(0.7),//fromRGBO(0, 44, 93, 1.0).withOpacity(0.3),//s.blue.shade900.withOpacity(0.5),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue.shade800,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.white,),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up,color: Colors.white,),
            label: '2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white,),
            label: '3',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body:  _pages[_currentIndex],
    );
  }
}


