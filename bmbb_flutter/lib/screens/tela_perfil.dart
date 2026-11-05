import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final usuario = authService.usuarioAtual;

    const Color corRosa = Color(0xFFBA149A);
    const Color corFundo = Color(0xFFFDF4FB);

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        title: Text(
          'Seu Perfil',
          style: GoogleFonts.fredoka(color: corRosa, fontWeight: FontWeight.bold),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar temporário do usuário
              CircleAvatar(
                radius: 50,
                backgroundColor: corRosa.withOpacity(0.2),
                backgroundImage: usuario?.photoURL != null ? NetworkImage(usuario!.photoURL!) : null,
                child: usuario?.photoURL == null
                    ? const Icon(Icons.person, size: 50, color: corRosa)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                usuario?.displayName ?? 'Criança',
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: corRosa,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                usuario?.email ?? '',
                style: GoogleFonts.fredoka(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              Text(
                'Em breve: escolha do avatar e estatísticas!',
                style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black45),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}