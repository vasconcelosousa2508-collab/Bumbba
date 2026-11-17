import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const rosaPrincipal = Color(0xFFBA149A);
  static const rosaClaro = Color(0xFFFDF4FB);
  static const rosaFeedback = Color(0xFFFF8AE8);
  static const rosaEscuro = Color(0xFF9C1181);
  static const rosaTransparente = Color(0x11BA149A);

  static const coral = Color(0xFFFA8772);
  static const turquesa = Color(0xFF7EC6CC);
  static const turquesaAlternativa = Color(0xFF7BC4C4);
  static const verdeLima = Color(0xFFCADD66);
  static const amarelo = Color(0xFFFFD734);
  static const roxo = Color(0xFF814777);
  static const roxoEscuro = Color(0xFF52284D);
  static const azulBarraProgresso = Color(0xFF7E98C5);

  static const azulSelecao = Color(0xFFC9E1F0);
  static const azulAtividade = Color(0xFF1CB0F6);
  static const verdeAssociacao = Color(0xFF88C838);
  static const vermelhoAssociacao = Color(0xFFFF4B4B);
  static const amareloAssociacao = Color(0xFFFFC800);
  static const roxoAssociacao = Color(0xFFCE82FF);

  static const cinzaBorda = Color(0xFFE5E5E5);
  static const cinzaCampo = Color(0xFFE0E0E0);
  static const cinzaClaro = Color(0xFFD9D9D9);
  static const cinzaTexto = Color(0xFF4B4B4B);
  static const cinzaTextoEscuro = Color(0xFF201B21);
  static const cinzaImagem = Color(0xFF3C3C3C);
  static const sombra = Color(0x18000000);
  static const sombraAlternativa = Color(0x14000000);
  static const sombraClara = Color(0x0F000000);
}

abstract final class AppPalettes {
  static const atividade = [
    AppColors.verdeLima,
    AppColors.turquesa,
    AppColors.roxo,
    AppColors.coral,
    AppColors.amarelo,
  ];

  static const associarImagem = [
    AppColors.verdeAssociacao,
    AppColors.azulAtividade,
    AppColors.vermelhoAssociacao,
    AppColors.amareloAssociacao,
    AppColors.roxoAssociacao,
  ];
}

abstract final class AppTextStyles {
  static TextStyle fredoka({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.fredoka(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
