import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetMultiplaEscolha extends StatelessWidget {
  final Map dados;

  const WidgetMultiplaEscolha({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);

    final String pergunta = dados['pergunta'] ?? '';
    final List opcoes = dados['opcoes'] ?? [];
    final int respostaCerta = dados['resposta_certa'] ?? 0;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            pergunta,
            style: GoogleFonts.fredoka(
              fontSize: 24,
              color: corRosa,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
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

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: acertou ? Colors.green : Colors.red,
                      content: Text(
                        acertou ? 'Muito bem! Você acertou!' : ' Ops! Tente novamente.',
                        style: GoogleFonts.fredoka(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
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