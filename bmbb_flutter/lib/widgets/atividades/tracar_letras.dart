// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'componentes_atividade.dart';
//
// class WidgetTracacaoLetra extends StatefulWidget {
//   final Map dados;
//
//   const WidgetTracacaoLetra({super.key, required this.dados});
//
//   @override
//   State<WidgetTracacaoLetra> createState() => _WidgetTracacaoLetraState();
// }
//
// class _WidgetTracacaoLetraState extends State<WidgetTracacaoLetra> {
//   final List<Offset?> _pontosTracado = [];
//   final Set<int> _checkpointsCobertos = {};
//   List<Offset> _checkpointsDaLetra = [];
//   bool _inicializado = false;
//
//   void _gerarCheckpoints(Size tamanhoCaixa) {
//     if (_inicializado) return;
//
//     final double centroX = tamanhoCaixa.width / 2;
//     final double centroY = tamanhoCaixa.height / 2;
//
//     _checkpointsDaLetra = [
//       Offset(centroX, centroY - 70),
//       Offset(centroX, centroY - 35),
//       Offset(centroX, centroY),
//       Offset(centroX, centroY + 35),
//       Offset(centroX, centroY + 70),
//       Offset(centroX - 35, centroY),
//       Offset(centroX + 35, centroY),
//     ];
//
//     _inicializado = true;
//   }
//
//   void _verificarToqueNoCheckpoint(Offset pontoLocal) {
//     for (int i = 0; i < _checkpointsDaLetra.length; i++) {
//       final double distancia = (pontoLocal - _checkpointsDaLetra[i]).distance;
//       if (distancia < 45.0) {
//         if (!_checkpointsCobertos.contains(i)) {
//           setState(() {
//             _checkpointsCobertos.add(i);
//           });
//         }
//       }
//     }
//   }
//
//   void _limparTracado() {
//     setState(() {
//       _pontosTracado.clear();
//       _checkpointsCobertos.clear();
//     });
//   }
//
//   void _verificarResposta() {
//     final double porcentagem = _checkpointsDaLetra.isNotEmpty
//         ? (_checkpointsCobertos.length / _checkpointsDaLetra.length)
//         : 0.0;
//
//     final bool acertou = porcentagem >= 0.60;
//
//     exibirFeedbackPadrao(
//       context: context,
//       acertou: acertou,
//       onAoFechar: () {
//         if (!acertou) {
//           _limparTracado();
//         }
//       },
//     );
//   }
//
//   Widget _buildPalavraApoio(String palavra, String letraAlvo) {
//     if (palavra.isEmpty) return const SizedBox.shrink();
//
//     final int index = palavra.toLowerCase().indexOf(letraAlvo.toLowerCase());
//     if (index == -1) {
//       return Text(
//         palavra,
//         style: GoogleFonts.fredoka(
//           fontSize: 32,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF3C3C3C),
//         ),
//       );
//     }
//
//     final String antes = palavra.substring(0, index);
//     final String letra = palavra.substring(index, index + letraAlvo.length);
//     final String depois = palavra.substring(index + letraAlvo.length);
//
//     return RichText(
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         style: GoogleFonts.fredoka(
//           fontSize: 34,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF3C3C3C),
//         ),
//         children: [
//           TextSpan(text: antes),
//           TextSpan(
//             text: letra,
//             style: const TextStyle(
//               color: Color(0xFF1CB0F6),
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           TextSpan(text: depois),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final String instrucao = widget.dados['instrucao'] ?? 'Trace a letra:';
//     final String letraAlvo = (widget.dados['texto'] ?? 'A').toString();
//     final String palavraCompleta = (widget.dados['palavra'] ?? '').toString();
//
//     const Color corRosa = Color(0xFFBA149A);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           TextoInstrucao(texto: instrucao),
//           const SizedBox(height: 8),
//
//           if (palavraCompleta.isNotEmpty)
//             _buildPalavraApoio(palavraCompleta, letraAlvo),
//
//           const SizedBox(height: 16),
//
//           // Quadro do Desenho
//           LayoutBuilder(
//             builder: (context, constraints) {
//               final double largura = constraints.maxWidth;
//               const double altura = 280.0;
//               final Size tamanhoCaixa = Size(largura, altura);
//
//               _gerarCheckpoints(tamanhoCaixa);
//
//               return Container(
//                 width: largura,
//                 height: altura,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color(0x0F000000),
//                       blurRadius: 10,
//                       offset: Offset(0, 4),
//                     )
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Text(
//                         letraAlvo,
//                         style: GoogleFonts.fredoka(
//                           fontSize: 190.0,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFFE5E5E5),
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//
//                       GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onPanStart: (details) {
//                           RenderBox renderBox = context.findRenderObject() as RenderBox;
//                           Offset local = renderBox.globalToLocal(details.globalPosition);
//                           setState(() {
//                             _pontosTracado.add(local);
//                           });
//                           _verificarToqueNoCheckpoint(local);
//                         },
//                         onPanUpdate: (details) {
//                           RenderBox renderBox = context.findRenderObject() as RenderBox;
//                           Offset local = renderBox.globalToLocal(details.globalPosition);
//                           setState(() {
//                             _pontosTracado.add(local);
//                           });
//                           _verificarToqueNoCheckpoint(local);
//                         },
//                         onPanEnd: (details) {
//                           setState(() {
//                             _pontosTracado.add(null);
//                           });
//                         },
//                         child: CustomPaint(
//                           size: tamanhoCaixa,
//                           painter: TracadoPainter(
//                             pontos: _pontosTracado,
//                             corTracado: corRosa,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           const SizedBox(height: 16),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton.icon(
//                 onPressed: _limparTracado,
//                 icon: const Icon(Icons.refresh_rounded, size: 22, color: Color(0xFF7EC6CC)),
//                 label: Text(
//                   "Limpar",
//                   style: GoogleFonts.fredoka(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF7EC6CC),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 48,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: corRosa,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 2,
//                   ),
//                   onPressed: _pontosTracado.isNotEmpty ? _verificarResposta : null,
//                   icon: const Icon(Icons.check_rounded, size: 24),
//                   label: Text(
//                     "Conferir",
//                     style: GoogleFonts.fredoka(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class TracadoPainter extends CustomPainter {
//   final List<Offset?> pontos;
//   final Color corTracado;
//
//   TracadoPainter({required this.pontos, required this.corTracado});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = corTracado
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 14.0;
//
//     for (int i = 0; i < pontos.length - 1; i++) {
//       if (pontos[i] != null && pontos[i + 1] != null) {
//         canvas.drawLine(pontos[i]!, pontos[i + 1]!, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant TracadoPainter oldDelegate) {
//     return true;
//   }
// }