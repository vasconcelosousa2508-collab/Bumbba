import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'componentes_atividade.dart';

class OpcaoLacuna {
  final int id;
  final String texto;
  final Color corTema;

  OpcaoLacuna({
    required this.id,
    required this.texto,
    required this.corTema,
  });
}

class WidgetCompletarLacuna extends StatefulWidget {
  final Map dados;

  const WidgetCompletarLacuna({super.key, required this.dados});

  @override
  State<WidgetCompletarLacuna> createState() => _WidgetCompletarLacunaState();
}

class _WidgetCompletarLacunaState extends State<WidgetCompletarLacuna> {
  List<OpcaoLacuna> _opcoes = [];
  OpcaoLacuna? _opcaoSelecionada;
  bool _inicializado = false;

  final List<Color> _paletaVibrante = const [
    Color(0xFFCADD66), // Verde Lima
    Color(0xFF7EC6CC), // Azul Turquesa
    Color(0xFFFA8772), // Salmão / Coral
    Color(0xFFFFD734), // Amarelo
    Color(0xFFBA149A), // Rosa Principal
  ];

  @override
  void initState() {
    super.initState();
    _inicializarAtividade();
  }

  void _inicializarAtividade() {
    final List opcoesBrutas = widget.dados['opcoes'] ?? [];
    final Random random = Random();

    List<OpcaoLacuna> listaTemporaria = [];
    for (int i = 0; i < opcoesBrutas.length; i++) {
      final Color corSorteada = _paletaVibrante[random.nextInt(_paletaVibrante.length)];
      listaTemporaria.add(OpcaoLacuna(
        id: i, // Guarda o índice original para comparar se resposta_certa for int
        texto: opcoesBrutas[i].toString(),
        corTema: corSorteada,
      ));
    }

    // Embaralha as opções para apresentação no ecrã
    listaTemporaria.shuffle();

    setState(() {
      _opcoes = listaTemporaria;
      _opcaoSelecionada = null;
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
    if (_opcaoSelecionada == null) return;

    bool acertou = false;
    final dynamic respostaCorretaBruta =
        widget.dados['resposta_certa'] ?? widget.dados['resposta_correta'];

    if (respostaCorretaBruta != null) {
      // Caso 1: resposta_certa no banco é um NÚMERO (índice, ex: 1)
      if (respostaCorretaBruta is int) {
        acertou = (_opcaoSelecionada!.id == respostaCorretaBruta);
      }
      // Caso 2: resposta_certa é uma STRING (ex: "A") ou número em formato texto ("1")
      else {
        final String valorBanco = respostaCorretaBruta.toString().trim().toUpperCase();

        // Verifica se é um número salvo como String (ex: "1")
        final int? indiceConvertido = int.tryParse(valorBanco);
        if (indiceConvertido != null) {
          acertou = (_opcaoSelecionada!.id == indiceConvertido);
        } else {
          // Comparação direta de texto (ex: "A" == "A")
          final String selecionado = _opcaoSelecionada!.texto.trim().toUpperCase();
          acertou = (selecionado == valorBanco);
        }
      }
    }

    exibirFeedbackPadrao(
      context: context,
      acertou: acertou,
      onAoFechar: () {
        if (!acertou) {
          setState(() {
            _opcaoSelecionada = null;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_inicializado) return const SizedBox.shrink();

    const Color corRosa = Color(0xFFBA149A);
    final String instrucao = widget.dados['instrucao'] ?? widget.dados['instrução'] ?? '';

    // Suporta 'texto' (novo padrão no banco) e 'texto_com_lacuna'
    final String textoComLacuna = widget.dados['texto'] ?? widget.dados['texto_com_lacuna'] ?? '';

    // Substitui o '_' pelo texto selecionado ou pela lacuna vazia
    final String textoExibido = _opcaoSelecionada != null
        ? textoComLacuna.replaceAll('_', ' ${_opcaoSelecionada!.texto} ')
        : textoComLacuna.replaceAll('_', ' ___ ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextoInstrucao(texto: instrucao),
          const SizedBox(height: 24),

          // Card da palavra com a lacuna + Botão Check
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 70),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: corRosa.withAlpha(100), width: 2),
                  ),
                  child: Text(
                    textoExibido,
                    style: GoogleFonts.fredoka(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF201B21),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 10),

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
                  onPressed: _opcaoSelecionada != null ? _verificarResposta : null,
                  child: const Icon(Icons.check, size: 28),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Banco de opções (letras / palavras)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: _opcoes.map((opcao) {
              final bool estaSelecionado = _opcaoSelecionada?.id == opcao.id;

              return SizedBox(
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: estaSelecionado ? Colors.white : opcao.corTema,
                    foregroundColor: estaSelecionado
                        ? opcao.corTema
                        : _corTextoParaFundo(opcao.corTema),
                    side: estaSelecionado
                        ? BorderSide(color: opcao.corTema, width: 2)
                        : BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    minimumSize: const Size(40, 44),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: estaSelecionado ? 2 : 0,
                  ),
                  onPressed: () {
                    setState(() {
                      if (estaSelecionado) {
                        _opcaoSelecionada = null;
                      } else {
                        _opcaoSelecionada = opcao;
                      }
                    });
                  },
                  child: Text(
                    opcao.texto,
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
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