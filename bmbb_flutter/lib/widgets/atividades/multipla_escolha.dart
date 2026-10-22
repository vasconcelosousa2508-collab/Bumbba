import 'package:flutter/material.dart';

class WidgetMultiplaEscolha extends StatelessWidget {
  final Map dados;

  const WidgetMultiplaEscolha({super.key, required this.dados});

  void _exibirFeedback(BuildContext context, bool acertou) {
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
              // Texto do Aviso
              Text(
                acertou ? 'Muito bem! Você acertou!' : 'Ops! Tente novamente.',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Botão
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
                    Navigator.pop(context); // Fecha o aviso
                    if (acertou) {
                      // Ação para continuar
                    }
                  },
                  child: Text(
                    acertou ? 'CONTINUAR' : 'TENTAR NOVAMENTE',
                    style: const TextStyle(
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
            style: const TextStyle(
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
                  _exibirFeedback(context, acertou);
                },
                child: Text(
                  opcoes[index].toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}