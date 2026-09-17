import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/livro.dart';
import 'tela_historia.dart';

class TelaBiblioteca extends StatelessWidget {
  const TelaBiblioteca({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Biblioteca de Histórias',
          style: TextStyle(
            color: Color(0xFFBA149A),
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
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
                childAspectRatio: 0.8,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final livro = Livro.fromFirestore(
                  docs[index].id,
                  docs[index].data() as Map<String, dynamic>,
                );

                return _criarCardLivro(context, livro);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _criarCardLivro(BuildContext context, Livro livro) {
    return Column(
      children: [
        Expanded(
          child: Material(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaHistoria(livro: livro),
                  ),
                );
              },
              child: livro.capaUrl.isNotEmpty
                  ? Image.network(
                livro.capaUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
              )
                  : const Center(child: Icon(Icons.menu_book, color: Colors.grey)),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          livro.titulo,
          style: const TextStyle(
            color: Color(0xFFBA149A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}