import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/livro.dart';
import '../services/auth_service.dart';
import 'tela_historia.dart';
import 'tela_selecionar_avatar.dart';

class _ItemProgressoPerfil {
  final Livro livro;
  final String faixaEtaria;
  final double progresso;

  _ItemProgressoPerfil({
    required this.livro,
    required this.faixaEtaria,
    required this.progresso,
  });
}

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  Widget _construirAvatar(String? avatarId) {
    if (avatarId == null || avatarId.isEmpty) {
      return Image.asset(
        'assets/login/bumbba-head.png',
        fit: BoxFit.contain,
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('avatar').doc(avatarId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Image.asset(
            'assets/login/bumbba-head.png',
            fit: BoxFit.contain,
          );
        }

        final avatarData = snapshot.data!.data() as Map<String, dynamic>?;
        final String url = avatarData?['url'] ?? '';

        if (url.isEmpty) {
          return Image.asset(
            'assets/login/bumbba-head.png',
            fit: BoxFit.contain,
          );
        }

        return Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/login/bumbba-head.png',
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Widget _construirMuralHorizontal({
    required BuildContext context,
    required String titulo,
    required List<_ItemProgressoPerfil> itens,
    required bool mostrarBarra,
  }) {
    const Color corRosa = Color(0xFFBA149A);
    const Color corBarra = Color(0xFF7E98C5);

    if (itens.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Text(
          titulo,
          style: GoogleFonts.fredoka(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: corRosa,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: mostrarBarra ? 205 : 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itens.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = itens[index];
              final int porcentagem = (item.progresso * 100).round();

              return SizedBox(
                width: 125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Material(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(18),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => TelaHistoria(
                                  livro: item.livro,
                                  faixaEtaria: item.faixaEtaria,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              item.livro.capaUrl.isNotEmpty
                                  ? Image.network(
                                item.livro.capaUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              )
                                  : const Center(
                                child: Icon(Icons.menu_book, color: Colors.grey),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${item.faixaEtaria}a',
                                    style: GoogleFonts.fredoka(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (mostrarBarra) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: corBarra, width: 1.5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: item.progresso.clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: corBarra,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$porcentagem%',
                            style: GoogleFonts.fredoka(
                              color: corBarra,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      item.livro.titulo,
                      style: GoogleFonts.fredoka(
                        color: corRosa,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final usuario = authService.usuarioAtual;

    const Color corRosa = Color(0xFFBA149A);
    const Color corFundo = Color(0xFFFDF4FB);
    const Color corTurquesa = Color(0xFF7BC4C4);

    if (usuario == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        title: Text(
          'Seu Perfil',
          style: GoogleFonts.fredoka(
            color: corRosa,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: corFundo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: corRosa),
            tooltip: 'Sair',
            onPressed: () async {
              await authService.sair();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: corRosa));
          }

          final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};

          // Dados da Criança
          final String nomeCrianca = data['nome_crianca'] ?? 'Pequeno Leitor';
          final int idadeCrianca = data['idade_crianca'] ?? 0;
          final String? avatarId = data['avatar_id'];

          // Dados do Responsável
          final String nomeResponsavel = data['nome_responsavel'] ?? usuario.displayName ?? 'Responsável';
          final String emailResponsavel = data['email_responsavel'] ?? usuario.email ?? '';

          // Dados de Progresso
          final Map<String, dynamic> mapaProgresso = data['historias_progresso'] is Map
              ? Map<String, dynamic>.from(data['historias_progresso'])
              : {};
          final Set<String> setConcluidas = data['historias_concluidas'] is List
              ? Set<String>.from(data['historias_concluidas'])
              : {};

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('livros').snapshots(),
            builder: (context, livrosSnapshot) {
              final List<_ItemProgressoPerfil> emAndamento = [];
              final List<_ItemProgressoPerfil> concluidos = [];

              if (livrosSnapshot.hasData) {
                final Map<String, Map<String, dynamic>> docsLivros = {
                  for (final doc in livrosSnapshot.data!.docs)
                    doc.id: doc.data() as Map<String, dynamic>
                };

                final Set<String> todasChaves = {
                  ...mapaProgresso.keys,
                  ...setConcluidas,
                };

                for (final chave in todasChaves) {
                  final int sepIndex = chave.indexOf('_');
                  if (sepIndex == -1) continue;

                  final String livroId = chave.substring(0, sepIndex);
                  final String faixa = chave.substring(sepIndex + 1);
                  final Map<String, dynamic>? dadosLivro = docsLivros[livroId];
                  if (dadosLivro == null) continue;

                  final Livro livro = Livro.fromFirestore(
                    livroId,
                    dadosLivro,
                    faixaEtaria: faixa,
                  );
                  if (!livro.temConteudo) continue;

                  final bool foiConcluida = setConcluidas.contains(chave);
                  final num? progBruto = mapaProgresso[chave];
                  final double prog = foiConcluida
                      ? 1.0
                      : (progBruto != null ? progBruto.toDouble() : 0.0);

                  if (foiConcluida || prog >= 1.0) {
                    concluidos.add(_ItemProgressoPerfil(
                      livro: livro,
                      faixaEtaria: faixa,
                      progresso: 1.0,
                    ));
                  } else if (prog > 0.0) {
                    emAndamento.add(_ItemProgressoPerfil(
                      livro: livro,
                      faixaEtaria: faixa,
                      progresso: prog,
                    ));
                  }
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => TelaSelecionarAvatar(
                                uid: usuario.uid,
                                avatarIdAtual: avatarId,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 155,
                              height: 155,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x18000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: _construirAvatar(avatarId),
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: corTurquesa, width: 3.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: corTurquesa,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Nome da criança centralizado
                    Text(
                      nomeCrianca,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        color: corRosa,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Idade discreta logo abaixo do nome
                    Text(
                      '$idadeCrianca anos',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    ),

                    // Mural: Continuar Lendo
                    _construirMuralHorizontal(
                      context: context,
                      titulo: 'Continuar Lendo',
                      itens: emAndamento,
                      mostrarBarra: true,
                    ),

                    // Mural: Histórias Concluídas
                    _construirMuralHorizontal(
                      context: context,
                      titulo: 'Histórias Concluídas',
                      itens: concluidos,
                      mostrarBarra: false,
                    ),

                    const SizedBox(height: 32),

                    // Card: Dados do Responsável
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DADOS DO RESPONSÁVEL',
                            style: GoogleFonts.fredoka(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.person_outline_rounded, color: Colors.black54, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  nomeResponsavel,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, color: Colors.black54, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  emailResponsavel,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}