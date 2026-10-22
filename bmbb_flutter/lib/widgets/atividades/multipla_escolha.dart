import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'componentes_atividade.dart';

class WidgetMultiplaEscolha extends StatelessWidget {
  final Map dados;

  const WidgetMultiplaEscolha({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    final String instrucao = dados['instrucao'] ?? dados['pergunta'] ?? '';
    final List opcoes = dados['opcoes'] ?? [];
    final int respostaCerta = dados['resposta_certa'] ?? 0;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextoInstrucao(texto: instrucao),
          const SizedBox(height: 32),
          ...List.generate(opcoes.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  final bool acertou = (index == respostaCerta);
                  exibirFeedbackPadrao(
                    context: context,
                    acertou: acertou,
                    onAoFechar: () {
                      if (acertou) {
                        // Ação de continuar
                      }
                    },
                  );
                },
                child: Text(
                  opcoes[index].toString(),
                  style: GoogleFonts.fredoka(fontSize: 20),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}