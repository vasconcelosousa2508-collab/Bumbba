import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/livro.dart';
import 'tela_historia.dart';
import 'tela_idade.dart';

class TelaBiblioteca extends StatefulWidget {
  const TelaBiblioteca({super.key});

  @override
  State createState() => _TelaBibliotecaState();
}

class _TelaBibliotecaState extends State {
  String _faixaSelecionada = '1 a 3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Biblioteca',
          style: TextStyle(
            color: Color(0xFFBA149A),
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelaIdade(),
                  ),
                );

                if (resultado != null) {
                  setState(() {
                    _faixaSelecionada = resultado;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA149A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
              label: Text('$_faixaSelecionada anos'),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
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

        final livros = docs
            .map((doc) => Livro.fromFirestore(
          doc.id,
          doc.data(),
          faixaEtaria: _faixaSelecionada,
        ))
            .where((livro) => livro.temConteudo)
            .toList();

        if (livros.isEmpty) {
          return const Center(
            child: Text('Nenhum livro disponível para esta idade'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.72,
            ),
            itemCount: livros.length,
            itemBuilder: (context, index) {
              return _criarCardLivro(context, livros[index]);
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
        AspectRatio(
          aspectRatio: 1.0,
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