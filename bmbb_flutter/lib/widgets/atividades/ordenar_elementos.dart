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

  const WidgetOrdenarElementos({super.key, required this.dados});

  @override
  State<WidgetOrdenarElementos> createState() => _WidgetOrdenarElementosState();
}

class _WidgetOrdenarElementosState extends State<WidgetOrdenarElementos> {
  List<ElementoOpcao> _bancoOpcoes = [];
  final List<ElementoOpcao> _respostaUsuario = [];
  bool _inicializado = false;

  final List<Color> _paletaVibrante = const [
    Color(0xFFCADD66), // Verde
    Color(0xFF7EC6CC), // Azul
    Color(0xFFFA8772), // Salmão
    Color(0xFFFFD734), // Amarelo
    Color(0xFFBA149A), // Roxo Principal
  ];

  @override
  void initState() {
    super.initState();
    _inicializarAtividade();
  }

  void _inicializarAtividade() {
    final List itensBrutos = widget.dados['itens'] ?? [];
    final Random random = Random();

    List<ElementoOpcao> listaTemporaria = [];
    for (int i = 0; i < itensBrutos.length; i++) {
      final Color corSorteada = _paletaVibrante[random.nextInt(_paletaVibrante.length)];

      listaTemporaria.add(ElementoOpcao(
        id: i,
        texto: itensBrutos[i].toString(),
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

  Color _corTextoParaFundo(Color fundo) {
    if (fundo == const Color(0xFFFFD734) || fundo == const Color(0xFFCADD66)) {
      return const Color(0xFF201B21);
    }
    return Colors.white;
  }

  void _verificarResposta() {
    if (_respostaUsuario.isEmpty) return;

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
        if (!acertou) {
          _inicializarAtividade();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_inicializado) return const SizedBox.shrink();

    const Color corRosa = Color(0xFFBA149A);
    final String instrucao = widget.dados['instrucao'] ?? widget.dados['instrução'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextoInstrucao(texto: instrucao),
          const SizedBox(height: 16),

          // ÁREA DE MONTAGEM DA RESPOSTA
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 56),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: corRosa.withAlpha(100), width: 2),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: _respostaUsuario.map((item) {
                      return SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: item.corTema,
                            side: BorderSide(color: item.corTema, width: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                            minimumSize: const Size(36, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 1,
                          ),
                          onPressed: () {
                            setState(() {
                              _respostaUsuario.remove(item);
                              _bancoOpcoes.add(item);
                            });
                          },
                          child: Text(
                            item.texto,
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Botão de Check
              SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corRosa,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 1,
                  ),
                  onPressed: _respostaUsuario.isNotEmpty ? _verificarResposta : null,
                  child: const Icon(
                    Icons.check,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // BANCO DE OPÇÕES
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6.0,
            runSpacing: 6.0,
            children: _bancoOpcoes.map((item) {
              return SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.corTema,
                    foregroundColor: _corTextoParaFundo(item.corTema),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    minimumSize: const Size(36, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      _bancoOpcoes.remove(item);
                      _respostaUsuario.add(item);
                    });
                  },
                  child: Text(
                    item.texto,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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