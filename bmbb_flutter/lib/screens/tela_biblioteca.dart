import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/livro.dart';
import 'tela_historia.dart';

class TelaBiblioteca extends StatelessWidget {
  const TelaBiblioteca({super.key});

  static const List<Color> _coresCard = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Biblioteca de Histórias',
          style: TextStyle(color: Color(0xFFBA149A), fontSize: 24.0),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('livros').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum livro encontrado'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final livro = Livro.fromFirestore(
                  docs[index].id,
                  docs[index].data() as Map<String, dynamic>,
                );

                final cor = _coresCard[index % _coresCard.length];

                return _criarQuadrado(context, livro, cor);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _criarQuadrado(BuildContext context, Livro livro, Color cor) {
    return Material(
      color: cor,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaHistoria(livro: livro),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              livro.titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}