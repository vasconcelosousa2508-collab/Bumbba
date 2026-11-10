import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final usuario = authService.usuarioAtual;

    const Color corRosa = Color(0xFFBA149A);
    const Color corFundo = Color(0xFFFDF4FB);

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
          style: GoogleFonts.fredoka(color: corRosa, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: corFundo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: corRosa),
            tooltip: 'Sair',
            onPressed: () async {
              // Apenas chama o método de logout; o StreamBuilder do main.dart redesenha a TelaLogin automaticamente
              await authService.sair();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};

          final String nomeCrianca = data['nome_crianca'] ?? 'Pequeno Leitor';
          final int idadeCrianca = data['idade_crianca'] ?? 0;

          final String nomeResponsavel = data['nome_responsavel'] ?? usuario.displayName ?? 'Responsável';
          final String emailResponsavel = data['email_responsavel'] ?? usuario.email ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: corRosa, width: 3),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/login/bumbba-head.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: corRosa,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DADOS DA CRIANÇA',
                        style: GoogleFonts.fredoka(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: corRosa,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.face_rounded, color: corRosa, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              nomeCrianca,
                              style: GoogleFonts.fredoka(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.cake_rounded, color: corRosa, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            '$idadeCrianca anos',
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 28),
                Text(
                  'Em breve: seletor de avatares do folclore e estatísticas de leitura!',
                  style: GoogleFonts.fredoka(fontSize: 14, color: Colors.black45),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}