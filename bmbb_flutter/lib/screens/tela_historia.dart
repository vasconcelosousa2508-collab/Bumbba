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
  final String faixaEtaria;

  const TelaHistoria({
    super.key,
    required this.livro,
    this.faixaEtaria = '1 a 3',
  });

  @override
  State<TelaHistoria> createState() => _TelaHistoriaState();
}

class _TelaHistoriaState extends State<TelaHistoria> {
  final Set<int> _atividadesConcluidas = {};
  final UsuarioService _usuarioService = UsuarioService();

  // Controller de rolagem e mapa de chaves para localizar as atividades pendentes
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _chavesBlocos = {};

  @override
  void initState() {
    super.initState();
    // Mapeia uma chave única para cada bloco de atividade
    for (int i = 0; i < widget.livro.blocos.length; i++) {
      if (widget.livro.blocos[i].tipo != 'texto_imagem') {
        _chavesBlocos[i] = GlobalKey();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get _totalAtividades {
    return widget.livro.blocos
        .where((bloco) => bloco.tipo != 'texto_imagem')
        .length;
  }

  // Retorna true quando todas as atividades foram respondidas com sucesso
  bool get _todasConcluidas {
    if (_totalAtividades == 0) return true;
    return _atividadesConcluidas.length == _totalAtividades;
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
          faixaEtaria: widget.faixaEtaria,
          progresso: progresso,
        );
      }
    }
  }

  void _finalizarHistoria() {
    // 1. Procura se há alguma atividade que ainda não foi concluída
    int? primeiroIndexPendente;
    for (int i = 0; i < widget.livro.blocos.length; i++) {
      if (widget.livro.blocos[i].tipo != 'texto_imagem' && !_atividadesConcluidas.contains(i)) {
        primeiroIndexPendente = i;
        break;
      }
    }

    // 2. Se houver pendência, avisa e rola suavemente até ela
    if (primeiroIndexPendente != null) {
      final keyPendente = _chavesBlocos[primeiroIndexPendente];
      if (keyPendente?.currentContext != null) {
        Scrollable.ensureVisible(
          keyPendente!.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFFA8772),
          content: Text(
            'Opa! Ainda tem atividade pendente!',
            style: GoogleFonts.fredoka(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      return;
    }

    // 3. Se tudo foi resolvido, conclui no Firebase e fecha a tela
    _usuarioService.concluirHistoria(
      livroId: widget.livro.id,
      faixaEtaria: widget.faixaEtaria,
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
          controller: _scrollController,
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

            // Envolve as atividades com a chave para localização no scroll
            final Key? widgetKey = _chavesBlocos[index];

            if (bloco.tipo == 'multipla_escolha') {
              return KeyedSubtree(
                key: widgetKey,
                child: WidgetMultiplaEscolha(
                  dados: bloco.dados,
                  onAcerto: () => _registrarAcerto(index),
                ),
              );
            }

            if (bloco.tipo == 'ordenar_elementos') {
              return KeyedSubtree(
                key: widgetKey,
                child: WidgetOrdenarElementos(
                  dados: bloco.dados,
                  onAcerto: () => _registrarAcerto(index),
                ),
              );
            }

            if (bloco.tipo == 'completar' || bloco.tipo == 'completar_lacuna') {
              return KeyedSubtree(
                key: widgetKey,
                child: WidgetCompletarLacuna(
                  dados: bloco.dados,
                  onAcerto: () => _registrarAcerto(index),
                ),
              );
            }

            if (bloco.tipo == 'associar_imagem' || bloco.tipo == 'associacao') {
              return KeyedSubtree(
                key: widgetKey,
                child: WidgetAssociarImagem(
                  dados: bloco.dados,
                  onAcerto: () => _registrarAcerto(index),
                ),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              child: ElevatedButton(
                onPressed: _finalizarHistoria,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _todasConcluidas
                      ? corRosa
                      : corRosa.withAlpha(80),
                  foregroundColor: _todasConcluidas
                      ? Colors.white
                      : Colors.white.withAlpha(180),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: _todasConcluidas ? 2 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Concluir História',
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        fontWeight: _todasConcluidas ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    if (_todasConcluidas) ...[
                      const SizedBox(width: 8),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}