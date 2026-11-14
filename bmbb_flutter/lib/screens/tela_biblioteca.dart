import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/livro.dart';
import 'tela_historia.dart';
import 'tela_idade.dart';

class TelaBiblioteca extends StatefulWidget {
  const TelaBiblioteca({super.key});

  @override
  State<TelaBiblioteca> createState() => _TelaBibliotecaState();
}

class _TelaBibliotecaState extends State<TelaBiblioteca> {
  String _faixaSelecionada = '1 a 3';

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Biblioteca',
          style: GoogleFonts.fredoka(
            color: corRosa,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final resultado = await Navigator.of(context, rootNavigator: true).push(
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
                backgroundColor: corRosa,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
              label: Text(
                '$_faixaSelecionada anos',
                style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: uid != null
            ? FirebaseFirestore.instance.collection('usuarios').doc(uid).snapshots()
            : const Stream.empty(),
        builder: (context, userSnapshot) {
          Map<String, dynamic> mapaProgresso = {};
          List<String> historiasConcluidas = [];

          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
            if (userData?['historias_progresso'] is Map) {
              mapaProgresso = Map<String, dynamic>.from(userData!['historias_progresso']);
            }
            if (userData?['historias_concluidas'] is List) {
              historiasConcluidas = List<String>.from(userData!['historias_concluidas']);
            }
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('livros').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar dados',
                    style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black54),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum livro encontrado',
                    style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black54),
                  ),
                );
              }

              final livros = docs
                  .map((doc) => Livro.fromFirestore(
                doc.id,
                doc.data() as Map,
                faixaEtaria: _faixaSelecionada,
              ))
                  .where((livro) => livro.temConteudo)
                  .toList();

              if (livros.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum livro disponível para esta idade',
                    style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black54),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.66,
                  ),
                  itemCount: livros.length,
                  itemBuilder: (context, index) {
                    final livro = livros[index];
                    final String chave = "${livro.id}_$_faixaSelecionada";
                    final num? valorBruto = mapaProgresso[chave];
                    double progresso = valorBruto != null ? valorBruto.toDouble() : 0.0;

                    if (historiasConcluidas.contains(chave)) {
                      progresso = 1.0;
                    }

                    return _criarCardLivro(context, livro, progresso);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _criarCardLivro(BuildContext context, Livro livro, double progresso) {
    const Color corRosa = Color(0xFFBA149A);
    const Color corBarra = Color(0xFF7E98C5);

    final bool mostrarBarra = progresso > 0.0;
    final int porcentagem = (progresso * 100).round();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Material(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _exibirModalConfirmacao(context, livro, _faixaSelecionada),
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
        if (mostrarBarra) ...[
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: progresso >= 1.0 ? corRosa : corBarra,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progresso.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: progresso >= 1.0 ? corRosa : corBarra,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                '$porcentagem %',
                style: GoogleFonts.fredoka(
                  color: progresso >= 1.0 ? corRosa : corBarra,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8.0),
        Text(
          livro.titulo,
          style: GoogleFonts.fredoka(
            color: corRosa,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// MODAL CARD
void _exibirModalConfirmacao(BuildContext context, Livro livro, String faixaEtaria) {
  const Color corRosa = Color(0xFFBA149A);

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Quer iniciar\nleitura?',
              style: GoogleFonts.fredoka(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: corRosa,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: corRosa, width: 2.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: livro.capaUrl.isNotEmpty
                    ? Image.network(
                  livro.capaUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                )
                    : const Icon(Icons.menu_book, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              livro.titulo,
              style: GoogleFonts.fredoka(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: corRosa,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: corRosa,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => TelaHistoria(
                        livro: livro,
                        faixaEtaria: faixaEtaria,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Vamos lá!',
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}