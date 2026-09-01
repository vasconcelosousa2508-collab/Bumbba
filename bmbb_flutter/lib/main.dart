import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MinhaPrimeiraTela(),
    );
  }
}

class MinhaPrimeiraTela extends StatelessWidget {
  const MinhaPrimeiraTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Biblioteca de Histórias',
            style: TextStyle(
              color: Color(0xFFBA149A),
              fontSize: 24.0,
            )
        ),
        // backgroundColor: const Color(0xFFBA149A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Margem nas bordas da tela
        child: GridView.count(
          crossAxisCount: 2, // Define 2 quadrados por linha
          mainAxisSpacing: 16.0, // Espaço vertical entre os quadrados
          crossAxisSpacing: 16.0, // Espaço horizontal entre os quadrados
          children: [
            _criarQuadrado('Saci Pererê', Colors.orange),
            _criarQuadrado('Curupira', Colors.green),
            _criarQuadrado('Iara', Colors.blue),
            _criarQuadrado('Boto Cor-de-Rosa', Colors.pink),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para criar cada quadrado sem repetir código
  Widget _criarQuadrado(String titulo, Color cor) {
    return Material(
      color: cor, // A cor vai no Material para a animação do clique funcionar
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: () {
          runApp(const MinhaOutraTela());
        },
        borderRadius: BorderRadius.circular(16.0), // Mantém o clique arredondado
        child: Center(
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class MinhaOutraTela extends StatelessWidget {
  const MinhaOutraTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'História muito legal',
            style: TextStyle(
              color: Color(0xFFBA149A),
              fontSize: 24.0,
            )
        ),
        // backgroundColor: const Color(0xFFBA149A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Margem nas bordas da tela
        child: Text(
            'Biblioteca de Histórias',
            style: TextStyle(
              color: Color(0xFFBA149A),
              fontSize: 24.0,
            )
        ),
        // child: GridView.count(
        //   crossAxisCount: 2, // Define 2 quadrados por linha
        //   mainAxisSpacing: 16.0, // Espaço vertical entre os quadrados
        //   crossAxisSpacing: 16.0, // Espaço horizontal entre os quadrados
        //   children: [
        //     _criarQuadrado('Saci Pererê', Colors.orange),
        //     _criarQuadrado('Curupira', Colors.green),
        //     _criarQuadrado('Iara', Colors.blue),
        //     _criarQuadrado('Boto Cor-de-Rosa', Colors.pink),
        //   ],
        // ),
      ),
    );
  }

}

