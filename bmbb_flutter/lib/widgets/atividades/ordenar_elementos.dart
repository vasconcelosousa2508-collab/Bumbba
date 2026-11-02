import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'componentes_atividade.dart';

class ElementoOpcao {
  final int id;
  final String texto;
  final Color corTema;

  ElementoOpcao({
    required this.id,
    required this.texto,
    required this.corTema,
  });
}

class WidgetOrdenarElementos extends StatefulWidget {
  final Map dados;
  final VoidCallback? onAcerto;

  const WidgetOrdenarElementos({
    super.key,
    required this.dados,
    this.onAcerto,
  });

  @override
  State<WidgetOrdenarElementos> createState() => _WidgetOrdenarElementosState();
}

class _WidgetOrdenarElementosState extends State<WidgetOrdenarElementos> {
  List<ElementoOpcao> _bancoOpcoes = [];
  final List<ElementoOpcao> _respostaUsuario = [];
  bool _inicializado = false;
  bool _concluido = false;

  // Sua paleta oficial
  final List<Color> _paletaApp = const [
    Color(0xFFCADD66),
    Color(0xFF7EC6CC),
    Color(0xFF814777),
    Color(0xFFFA8772),
    Color(0xFFFFD734),
  ];

  @override
  void initState() {
    super.initState();
    _inicializarAtividade();
  }

  void _inicializarAtividade() {
    final List opcoesBrutas = widget.dados['opcoes'] ?? widget.dados['itens'] ?? [];
    final Random random = Random();

    List<ElementoOpcao> listaTemporaria = [];
    for (int i = 0; i < opcoesBrutas.length; i++) {
      final Color corSorteada = _paletaApp[random.nextInt(_paletaApp.length)];
      listaTemporaria.add(ElementoOpcao(
        id: i,
        texto: opcoesBrutas[i].toString(),
        corTema: corSorteada,
      ));
    }
    listaTemporaria.shuffle();

    setState(() {
      _bancoOpcoes = listaTemporaria;
      _respostaUsuario.clear();
      _inicializado = true;
    });
  }

  void _verificarResposta() {
    if (_respostaUsuario.isEmpty || _concluido) return;

    bool acertou = false;
    final dynamic respostaCorretaBruta =
        widget.dados['resposta_certa'] ?? widget.dados['resposta_correta'];

    if (respostaCorretaBruta != null) {
      final String textoMontado = _respostaUsuario
          .map((e) => e.texto.trim())
          .join()
          .toUpperCase();

      String textoEsperado = '';

      if (respostaCorretaBruta is List) {
        textoEsperado = respostaCorretaBruta
            .map((e) => e.toString().trim())
            .join()
            .toUpperCase();
      } else if (respostaCorretaBruta is String) {
        textoEsperado = respostaCorretaBruta.trim().toUpperCase();
      }

      acertou = (textoMontado == textoEsperado);
    }

    exibirFeedbackPadrao(
      context: context,
      acertou: acertou,
      onAoFechar: () {
        if (acertou) {
          setState(() => _concluido = true);
          widget.onAcerto?.call();
        } else {
          _inicializarAtividade();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_inicializado) return const SizedBox.shrink();

    final String instrucao = widget.dados['instrucao'] ?? widget.dados['instrução'] ?? '';

    final Color corCaixaFundo = _concluido ? const Color(0xFFFF8AE8) : Colors.white;
    final Color corCaixaBorda = _concluido ? const Color(0xFFBA149A) : const Color(0xFFE5E5E5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextoInstrucao(texto: instrucao),
          const SizedBox(height: 20),

          // Área de Montagem
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  constraints: const BoxConstraints(minHeight: 64),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: corCaixaFundo,
                    borderRadius: BorderRadius.circular(20),
                    border: Border(
                      top: BorderSide(color: corCaixaBorda, width: 2),
                      left: BorderSide(color: corCaixaBorda, width: 2),
                      right: BorderSide(color: corCaixaBorda, width: 2),
                      bottom: BorderSide(color: corCaixaBorda, width: 4),
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _respostaUsuario.map((item) {
                      return GestureDetector(
                        onTap: _concluido
                            ? null
                            : () {
                          setState(() {
                            _respostaUsuario.remove(item);
                            _bancoOpcoes.add(item);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _concluido ? Colors.white : item.corTema,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _concluido ? const Color(0xFFBA149A) : item.corTema,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            item.texto,
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _concluido ? const Color(0xFF9C1181) : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (!_concluido) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _respostaUsuario.isNotEmpty ? _verificarResposta : null,
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: _respostaUsuario.isNotEmpty
                          ? const Color(0xFF814777)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                        bottom: BorderSide(
                          color: _respostaUsuario.isNotEmpty
                              ? const Color(0xFF52284D)
                              : Colors.grey[400]!,
                          width: 4,
                        ),
                      ),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 28),
                  ),
                ),
              ]
            ],
          ),

          const SizedBox(height: 20),

          // Banco de Opções (Coloridos com baixa opacidade)
          if (!_concluido)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 8.0,
              children: _bancoOpcoes.map((item) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _bancoOpcoes.remove(item);
                      _respostaUsuario.add(item);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: item.corTema.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                        top: BorderSide(color: item.corTema, width: 2),
                        left: BorderSide(color: item.corTema, width: 2),
                        right: BorderSide(color: item.corTema, width: 2),
                        bottom: BorderSide(color: item.corTema, width: 4),
                      ),
                    ),
                    child: Text(
                      item.texto,
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: item.corTema,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}