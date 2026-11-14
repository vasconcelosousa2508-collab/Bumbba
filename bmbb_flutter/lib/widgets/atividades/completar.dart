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
  final VoidCallback? onAcerto;
  final bool jaConcluido;

  const WidgetCompletarLacuna({
    super.key,
    required this.dados,
    this.onAcerto,
    this.jaConcluido = false,
  });

  @override
  State<WidgetCompletarLacuna> createState() => _WidgetCompletarLacunaState();
}

class _WidgetCompletarLacunaState extends State<WidgetCompletarLacuna> {
  List<OpcaoLacuna> _opcoes = [];
  OpcaoLacuna? _opcaoSelecionada;
  bool _inicializado = false;
  late bool _concluido;

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
    _concluido = widget.jaConcluido;
    _inicializarAtividade();
  }

  @override
  void didUpdateWidget(covariant WidgetCompletarLacuna oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.jaConcluido && !_concluido) {
      setState(() {
        _concluido = true;
        _selecionarRespostaCorretaAutomaticamente();
      });
    }
  }

  bool _ehOpcaoCorreta(OpcaoLacuna opcao) {
    final dynamic respostaCorretaBruta =
        widget.dados['resposta_certa'] ?? widget.dados['resposta_correta'];
    if (respostaCorretaBruta == null) return false;

    if (respostaCorretaBruta is int) {
      return opcao.id == respostaCorretaBruta;
    } else {
      final String valorBanco = respostaCorretaBruta.toString().trim().toUpperCase();
      final int? indiceConvertido = int.tryParse(valorBanco);
      if (indiceConvertido != null) {
        return opcao.id == indiceConvertido;
      }
      return opcao.texto.trim().toUpperCase() == valorBanco;
    }
  }

  void _selecionarRespostaCorretaAutomaticamente() {
    for (final op in _opcoes) {
      if (_ehOpcaoCorreta(op)) {
        _opcaoSelecionada = op;
        break;
      }
    }
  }

  void _inicializarAtividade() {
    final List opcoesBrutas = widget.dados['opcoes'] ?? [];
    final Random random = Random();

    List<OpcaoLacuna> listaTemporaria = [];
    for (int i = 0; i < opcoesBrutas.length; i++) {
      final Color corSorteada = _paletaApp[random.nextInt(_paletaApp.length)];
      listaTemporaria.add(OpcaoLacuna(
        id: i,
        texto: opcoesBrutas[i].toString(),
        corTema: corSorteada,
      ));
    }
    listaTemporaria.shuffle();

    setState(() {
      _opcoes = listaTemporaria;
      _opcaoSelecionada = null;
      _inicializado = true;
      if (_concluido) {
        _selecionarRespostaCorretaAutomaticamente();
      }
    });
  }

  void _selecionarEVerificar(OpcaoLacuna opcao) {
    if (_concluido) return;

    setState(() {
      _opcaoSelecionada = opcao;
    });

    final bool acertou = _ehOpcaoCorreta(opcao);

    exibirFeedbackPadrao(
      context: context,
      acertou: acertou,
      onAoFechar: () {
        if (acertou) {
          setState(() => _concluido = true);
          widget.onAcerto?.call();
        } else {
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

    final String instrucao = widget.dados['instrucao'] ?? widget.dados['instrução'] ?? '';
    final String textoComLacuna = widget.dados['texto'] ?? widget.dados['texto_com_lacuna'] ?? '';

    final String textoExibido = _opcaoSelecionada != null
        ? textoComLacuna.replaceAll('_', ' ${_opcaoSelecionada!.texto} ')
        : textoComLacuna.replaceAll('_', ' ___ ');

    final Color corContainerFundo = _concluido ? const Color(0xFFFF8AE8) : Colors.white;
    final Color corContainerBorda = _concluido ? const Color(0xFFBA149A) : const Color(0xFFE5E5E5);
    final Color corContainerTexto = _concluido ? const Color(0xFF9C1181) : const Color(0xFF201B21);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextoInstrucao(texto: instrucao),
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 80),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: corContainerFundo,
              borderRadius: BorderRadius.circular(20),
              border: Border(
                top: BorderSide(color: corContainerBorda, width: 2),
                left: BorderSide(color: corContainerBorda, width: 2),
                right: BorderSide(color: corContainerBorda, width: 2),
                bottom: BorderSide(color: corContainerBorda, width: 4),
              ),
            ),
            child: Text(
              textoExibido,
              style: GoogleFonts.fredoka(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: corContainerTexto,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          if (!_concluido)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              runSpacing: 12.0,
              children: _opcoes.map((opcao) {
                final bool estaSelecionado = _opcaoSelecionada?.id == opcao.id;

                final Color corFundo = estaSelecionado
                    ? opcao.corTema
                    : opcao.corTema.withOpacity(0.18);
                final Color corTexto = estaSelecionado
                    ? Colors.white
                    : opcao.corTema;

                return GestureDetector(
                  onTap: () => _selecionarEVerificar(opcao),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: corFundo,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                        top: BorderSide(color: opcao.corTema, width: 2),
                        left: BorderSide(color: opcao.corTema, width: 2),
                        right: BorderSide(color: opcao.corTema, width: 2),
                        bottom: BorderSide(color: opcao.corTema, width: estaSelecionado ? 2 : 4),
                      ),
                    ),
                    child: Text(
                      opcao.texto,
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: corTexto,
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