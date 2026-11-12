import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'componentes_atividade.dart';

class WidgetMultiplaEscolha extends StatefulWidget {
  final Map dados;
  final VoidCallback? onAcerto;

  const WidgetMultiplaEscolha({
    super.key,
    required this.dados,
    this.onAcerto,
  });

  @override
  State<WidgetMultiplaEscolha> createState() => _WidgetMultiplaEscolhaState();
}

class _WidgetMultiplaEscolhaState extends State<WidgetMultiplaEscolha> {
  int? _opcaoSelecionada;
  bool _concluido = false;

  void _selecionarEVerificar(int index, int respostaCerta) {
    if (_concluido) return;

    setState(() => _opcaoSelecionada = index);
    final bool acertou = (index == respostaCerta);

    exibirFeedbackPadrao(
      context: context,
      acertou: acertou,
      onAoFechar: () {
        if (acertou) {
          setState(() => _concluido = true);
          widget.onAcerto?.call();
        } else {
          setState(() => _opcaoSelecionada = null);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String instrucao = widget.dados['instrucao'] ?? widget.dados['pergunta'] ?? '';
    final List opcoes = widget.dados['opcoes'] ?? [];
    final int respostaCerta = widget.dados['resposta_certa'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextoInstrucao(texto: instrucao),
          const SizedBox(height: 24),
          ...List.generate(opcoes.length, (index) {
            final bool estaSelecionado = _opcaoSelecionada == index;
            final bool ehCorretaEConcluida = _concluido && index == respostaCerta;

            final Color corFundo = ehCorretaEConcluida
                ? const Color(0xFFFF8AE8)
                : (estaSelecionado ? const Color(0xFFC9E1F0) : Colors.white);
            final Color corBorda = ehCorretaEConcluida
                ? const Color(0xFFBA149A)
                : (estaSelecionado ? const Color(0xFF1CB0F6) : const Color(0xFFE5E5E5));
            final Color corTexto = ehCorretaEConcluida
                ? const Color(0xFF9C1181)
                : (estaSelecionado ? const Color(0xFF1CB0F6) : const Color(0xFF4B4B4B));

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: () => _selecionarEVerificar(index, respostaCerta),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 56),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: corFundo,
                    borderRadius: BorderRadius.circular(16),
                    border: Border(
                      top: BorderSide(color: corBorda, width: 2),
                      left: BorderSide(color: corBorda, width: 2),
                      right: BorderSide(color: corBorda, width: 2),
                      bottom: BorderSide(
                        color: corBorda,
                        width: estaSelecionado || ehCorretaEConcluida ? 2 : 4,
                      ),
                    ),
                  ),
                  child: Text(
                    opcoes[index].toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: corTexto,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}