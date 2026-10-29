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
    Color(0xFFBA149A), // Rosa / Roxo Principal
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
        id: i, // Preserva o índice original para comparar com resposta_certa int
        texto: opcoesBrutas[i].toString(),
        corTema: corSorteada,
      ));
    }

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

  void _selecionarEVerificar(OpcaoLacuna opcao) {
    setState(() {
      _opcaoSelecionada = opcao;
    });

    bool acertou = false;
    final dynamic respostaCorretaBruta =
        widget.dados['resposta_certa'] ?? widget.dados['resposta_correta'];

    if (respostaCorretaBruta != null) {
      if (respostaCorretaBruta is int) {
        acertou = (opcao.id == respostaCorretaBruta);
      } else {
        final String valorBanco = respostaCorretaBruta.toString().trim().toUpperCase();
        final int? indiceConvertido = int.tryParse(valorBanco);

        if (indiceConvertido != null) {
          acertou = (opcao.id == indiceConvertido);
        } else {
          final String selecionado = opcao.texto.trim().toUpperCase();
          acertou = (selecionado == valorBanco);
        }
      }
    }

    // Exibe o feedback instantâneo ao clicar
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
    final String textoComLacuna = widget.dados['texto'] ?? widget.dados['texto_com_lacuna'] ?? '';

    // Preenche a lacuna com a opção escolhida ou deixa o espaço em branco
    final String textoExibido = _opcaoSelecionada != null
        ? textoComLacuna.replaceAll('_', ' ${_opcaoSelecionada!.texto} ')
        : textoComLacuna.replaceAll('_', ' ___ ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Instrução
          TextoInstrucao(texto: instrucao),
          const SizedBox(height: 24),

          // 2. Card Central com o Texto da Lacuna (agora ocupa toda a largura sem o botão de check)
          Container(
            width: double.infinity,
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

          const SizedBox(height: 32),

          // 3. Banco de Opções (Clique direto valida a resposta)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.0,
            runSpacing: 10.0,
            children: _opcoes.map((opcao) {
              final bool estaSelecionado = _opcaoSelecionada?.id == opcao.id;

              return SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: estaSelecionado ? Colors.white : opcao.corTema,
                    foregroundColor: estaSelecionado
                        ? opcao.corTema
                        : _corTextoParaFundo(opcao.corTema),
                    side: estaSelecionado
                        ? BorderSide(color: opcao.corTema, width: 2)
                        : BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    minimumSize: const Size(44, 48),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: estaSelecionado ? 2 : 0,
                  ),
                  onPressed: () => _selecionarEVerificar(opcao),
                  child: Text(
                    opcao.texto,
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
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