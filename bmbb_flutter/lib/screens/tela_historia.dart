import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/livro.dart';
import '../services/usuario_service.dart';

import '../widgets/atividades/multipla_escolha.dart';
import '../widgets/atividades/ordenar_elementos.dart';
import '../widgets/atividades/completar.dart';
import '../widgets/atividades/associar_imagem.dart';

class TelaHistoria extends StatefulWidget {
  final Livro livro;

  const TelaHistoria({super.key, required this.livro});

  @override
  State<TelaHistoria> createState() => _TelaHistoriaState();
}

class _TelaHistoriaState extends State<TelaHistoria> {
  final Set<int> _atividadesConcluidas = {};
  final UsuarioService _usuarioService = UsuarioService();

  // Conta dinamicamente apenas os blocos que são atividades
  int get _totalAtividades {
    return widget.livro.blocos
        .where((bloco) => bloco.tipo != 'texto_imagem')
        .length;
  }

  void _registrarAcerto(int indexBloco) {
    if (!_atividadesConcluidas.contains(indexBloco)) {
      setState(() {
        _atividadesConcluidas.add(indexBloco);
      });

      if (_totalAtividades > 0) {
        final double progresso = _atividadesConcluidas.length / _totalAtividades;

        _usuarioService.salvarProgresso(
          livroId: widget.livro.id,
          faixaEtaria: '1-3', // Chave da faixa
          progresso: progresso,
        );
      }
    }
  }

  void _finalizarHistoria() {
    _usuarioService.concluirHistoria(
      livroId: widget.livro.id,
      faixaEtaria: '1-3',
    );
    Navigator.pop(context);
  }

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
          widget.livro.titulo,
          style: GoogleFonts.fredoka(
            color: corRosa,
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: widget.livro.blocos.isNotEmpty
            ? ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: widget.livro.blocos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 24.0),
          itemBuilder: (context, index) {
            final bloco = widget.livro.blocos[index];

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
              return WidgetMultiplaEscolha(
                dados: bloco.dados,
                onAcerto: () => _registrarAcerto(index),
              );
            }

            if (bloco.tipo == 'ordenar_elementos') {
              return WidgetOrdenarElementos(
                dados: bloco.dados,
                onAcerto: () => _registrarAcerto(index),
              );
            }

            if (bloco.tipo == 'completar' || bloco.tipo == 'completar_lacuna') {
              return WidgetCompletarLacuna(
                dados: bloco.dados,
                onAcerto: () => _registrarAcerto(index),
              );
            }

            if (bloco.tipo == 'associar_imagem' || bloco.tipo == 'associacao') {
              return WidgetAssociarImagem(
                dados: bloco.dados,
                onAcerto: () => _registrarAcerto(index),
              );
            }

            return const SizedBox.shrink();
          },
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Text(
              widget.livro.historiaTexto,
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _finalizarHistoria,
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