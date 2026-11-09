import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tela_biblioteca.dart';
import 'tela_perfil.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _abaSelecionada = 0;

  final List<Widget> _telas = const [
    TelaBiblioteca(),
    TelaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);

    return Scaffold(
      body: IndexedStack(
        index: _abaSelecionada,
        children: _telas,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _abaSelecionada,
          onTap: (index) {
            setState(() {
              _abaSelecionada = index;
            });
          },
          selectedItemColor: corRosa,
          unselectedItemColor: Colors.black38,
          selectedLabelStyle: GoogleFonts.fredoka(fontWeight: FontWeight.normal, fontSize: 13),
          unselectedLabelStyle: GoogleFonts.fredoka(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              label: 'Biblioteca',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Você',
            ),
          ],
        ),
      ),
    );
  }
}