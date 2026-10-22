import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextoInstrucao extends StatelessWidget {
  final String texto;

  const TextoInstrucao({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);

    return Text(
      texto,
      style: GoogleFonts.fredoka(
        fontSize: 22,
        color: corRosa,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}

void exibirFeedbackPadrao({
  required BuildContext context,
  required bool acertou,
  required VoidCallback onAoFechar,
}) {
  const Color corRosa = Color(0xFFBA149A);

  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        width: double.infinity,
        color: acertou ? const Color(0xFF7EC6CC) : const Color(0xFFFA8772),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              acertou ? 'Muito bem! Você acertou!' : 'Ops! Tente novamente.',
              style: GoogleFonts.fredoka(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: corRosa,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onAoFechar();
                },
                child: Text(
                  acertou ? 'CONTINUAR' : 'TENTAR NOVAMENTE',
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}