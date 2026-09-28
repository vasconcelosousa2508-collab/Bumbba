import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/livro.dart';

class TelaHistoria extends StatelessWidget {
  final Livro livro;

  const TelaHistoria({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: corRosa),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          livro.titulo,
          style: GoogleFonts.fredoka(
            color: corRosa,
            fontSize: 22.0,
            fontWeight: FontWeight.w500, // Menos pesado que o bold tradicional
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Text(
              livro.historia,
              style: GoogleFonts.fredoka(
                fontSize: 20, // Fonte bem maior para facilitar a leitura das crianças
                height: 1.6,
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