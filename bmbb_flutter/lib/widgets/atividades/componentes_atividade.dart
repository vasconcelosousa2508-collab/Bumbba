import 'package:flutter/material.dart';
import '../../theme/app_design.dart';

class TextoInstrucao extends StatelessWidget {
  final String texto;

  const TextoInstrucao({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    const Color corRosa = AppColors.rosaPrincipal;

    return Text(
      texto,
      style: AppTextStyles.fredoka(
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
  const Color corRosa = AppColors.rosaPrincipal;

  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        width: double.infinity,
        color: acertou ? AppColors.turquesa : AppColors.coral,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              acertou ? 'Muito bem! Você acertou!' : 'Vish! Tente novamente.',
              style: AppTextStyles.fredoka(
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
                  style: AppTextStyles.fredoka(
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