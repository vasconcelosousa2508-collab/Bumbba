import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../models/livro.dart';

import '../widgets/atividades/multipla_escolha.dart';
import '../widgets/atividades/ordenar_elementos.dart';
import '../widgets/atividades/completar.dart';

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
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: livro.blocos.isNotEmpty
            ? ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: livro.blocos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 24.0),
          itemBuilder: (context, index) {
            final bloco = livro.blocos[index];

            if (bloco.tipo == 'texto_imagem') {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  bloco.dados['texto'] ?? '',
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              );
            }

            if (bloco.tipo == 'multipla_escolha') {
              return WidgetMultiplaEscolha(dados: bloco.dados);
            }

            if (bloco.tipo == 'ordenar_elementos') {
              return WidgetOrdenarElementos(dados: bloco.dados);
            }

            if (bloco.tipo == 'completar' || bloco.tipo == 'completar_lacuna') {
              return WidgetCompletarLacuna(dados: bloco.dados);
            }

            return const SizedBox.shrink();
          },
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Text(
              livro.historiaTexto,
              style: GoogleFonts.fredoka(
                fontSize: 20,
                height: 1.6,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
      // BOTÃO
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: corRosa,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Concluir História',
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}