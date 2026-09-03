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
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _criarQuadrado(context, 'Saci Pererê', Colors.orange),
            _criarQuadrado(context, 'Curupira', Colors.green),
            _criarQuadrado(context, 'Iara', Colors.blue),
            _criarQuadrado(context, 'Boto Cor-de-Rosa', Colors.pink),
          ],
        ),
      ),
    );
  }

  Widget _criarQuadrado(BuildContext context, String titulo, Color cor) {
    return Material(
      color: cor,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: () {
          // Usa o Navigator para ir para a nova tela
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaHistoria(tituloHistoria: titulo),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.0),
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

// Modelo de tela para a história
class TelaHistoria extends StatelessWidget {
  final String tituloHistoria;

  const TelaHistoria({super.key, required this.tituloHistoria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Adiciona a seta de voltar automaticamente
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFBA149A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          tituloHistoria,
          style: const TextStyle(
            color: Color(0xFFBA149A),
            fontSize: 24.0,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                  'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in '
                  'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
              style: TextStyle(
                fontSize: 16.0,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}