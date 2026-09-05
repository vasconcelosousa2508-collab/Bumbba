// CONFIGURAÇÕES
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MeuApp());
}

// MODELS
class Livro {
  final String id;
  final String titulo;
  final String historia;

  Livro({
    required this.id,
    required this.titulo,
    required this.historia,
  });

  factory Livro.fromFirestore(String id, Map<String, dynamic> data) {
    return Livro(
      id: id,
      titulo: data['titulo'] ?? '',
      historia: data['historia'] ?? '',
    );
  }
}

// APP
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

// TELAS
class MinhaPrimeiraTela extends StatelessWidget {
  const MinhaPrimeiraTela({super.key});

  // Lista de cores para alternar no Grid
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

                // Alterna entre as cores da lista
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

class TelaHistoria extends StatelessWidget {
  final Livro livro;

  const TelaHistoria({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFBA149A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          livro.titulo,
          style: const TextStyle(color: Color(0xFFBA149A), fontSize: 24.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              livro.historia,
              style: const TextStyle(
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