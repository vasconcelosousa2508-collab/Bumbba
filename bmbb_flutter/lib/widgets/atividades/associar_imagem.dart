import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'componentes_atividade.dart';

class OpcaoAssociacao {
  final int id;
  final String valor;
  final Color corTema;

  OpcaoAssociacao({
    required this.id,
    required this.valor,
    required this.corTema,
  });
}

class WidgetAssociarImagem extends StatefulWidget {
  final Map dados;

  const WidgetAssociarImagem({super.key, required this.dados});

  @override
  State<WidgetAssociarImagem> createState() => _WidgetAssociarImagemState();
}

class _WidgetAssociarImagemState extends State<WidgetAssociarImagem> {
  List<OpcaoAssociacao> _opcoes = [];
  OpcaoAssociacao? _opcaoSelecionada;
  bool _inicializado = false;

  final List<Color> _paletaVibrante = const [
    Color(0xFF88C838), // Verde estilo Duolingo
    Color(0xFF1CB0F6), // Azul
    Color(0xFFFF4B4B), // Coral / Vermelho
    Color(0xFFFFC800), // Amarelo
    Color(0xFFCE82FF), // Roxo
  ];

  @override
  void initState() {
    super.initState();
    _inicializarAtividade();
  }

  void _inicializarAtividade() {
    final List opcoesBrutas = widget.dados['opcoes'] ?? widget.dados['opcoes_imagens'] ?? [];
    final Random random = Random();

    List<OpcaoAssociacao> listaTemporaria = [];
    for (int i = 0; i < opcoesBrutas.length; i++) {
      final Color corSorteada = _paletaVibrante[random.nextInt(_paletaVibrante.length)];
      listaTemporaria.add(OpcaoAssociacao(
        id: i,
        valor: opcoesBrutas[i].toString(),
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

  void _selecionarEVerificar(OpcaoAssociacao opcao) {
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
          final String selecionado = opcao.valor.trim().toUpperCase();
          acertou = (selecionado == valorBanco);
        }
      }
    }

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

    final String instrucao = widget.dados['instrucao'] ?? widget.dados['instrução'] ?? '';
    final String? imagemCentral = widget.dados['imagem'] ?? widget.dados['imagem_central'];
    final String? textoCentral = widget.dados['texto'] ?? widget.dados['texto_central'];
    final bool ehOpcoesComImagem = widget.dados.containsKey('opcoes_imagens');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Instrução Clean
          TextoInstrucao(texto: instrucao),
          const SizedBox(height: 24),

          // 2. Elemento Central Limpo (Sem containers poluídos)
          if (textoCentral != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                textoCentral.toLowerCase(), // Duolingo usa caixa baixa/limpa
                style: GoogleFonts.fredoka(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3C3C3C),
                ),
                textAlign: TextAlign.center,
              ),
            )
          else if (imagemCentral != null)
            Container(
              height: 150,
              width: 150,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Image.network(
                imagemCentral,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),

          const SizedBox(height: 20),

          // 3. Grid / Opções (Cards Estilo Duolingo)
          if (ehOpcoesComImagem)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: _opcoes.length,
              itemBuilder: (context, index) {
                final opcao = _opcoes[index];
                final bool estaSelecionado = _opcaoSelecionada?.id == opcao.id;

                return GestureDetector(
                  onTap: () => _selecionarEVerificar(opcao),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // Fundo verde claro/suave quando selecionado, branco quando neutro
                      color: estaSelecionado
                          ? const Color(0xFFD7FFB8)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                        top: BorderSide(
                          color: estaSelecionado ? const Color(0xFF84D82D) : const Color(0xFFE5E5E5),
                          width: 2,
                        ),
                        left: BorderSide(
                          color: estaSelecionado ? const Color(0xFF84D82D) : const Color(0xFFE5E5E5),
                          width: 2,
                        ),
                        right: BorderSide(
                          color: estaSelecionado ? const Color(0xFF84D82D) : const Color(0xFFE5E5E5),
                          width: 2,
                        ),
                        // Efeito de relevo/3D na borda inferior
                        bottom: BorderSide(
                          color: estaSelecionado ? const Color(0xFF84D82D) : const Color(0xFFE5E5E5),
                          width: estaSelecionado ? 2 : 5,
                        ),
                      ),
                    ),
                    child: Image.network(
                      opcao.valor,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            )
          else
          // Opções de Texto (Cards retangulares estilo Duolingo)
            Column(
              children: _opcoes.map((opcao) {
                final bool estaSelecionado = _opcaoSelecionada?.id == opcao.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () => _selecionarEVerificar(opcao),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: double.infinity,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: estaSelecionado
                            ? const Color(0xFFD7FFB8)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          top: BorderSide(
                            color: estaSelecionado ? const Color(0xFF84D82D) : const Color(0xFFE5E5E5),
                            width: 2,
                          ),
                          left: BorderSide(
                            color: estaSelecionado ? const Color(0xFF84D82D) : const Color(0xFFE5E5E5),
                            width: 2,
                          ),
                          right: BorderSide(
                            color: estaSelecionado ? const Color(0xFF84D82D) : const Color(0xFFE5E5E5),
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: estaSelecionado ? const Color(0xFF84D82D) : const Color(0xFFE5E5E5),
                            width: estaSelecionado ? 2 : 4,
                          ),
                        ),
                      ),
                      child: Text(
                        opcao.valor,
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: estaSelecionado
                              ? const Color(0xFF58A700)
                              : const Color(0xFF4B4B4B),
                        ),
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