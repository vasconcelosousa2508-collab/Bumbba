import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import 'tela_selecionar_avatar.dart';

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

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                // Avatar grande centralizado com lápis no canto superior direito
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
                    // fontWeight: FontWeight.bold,
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
      ),
    );
  }
}