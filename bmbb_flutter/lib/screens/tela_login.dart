import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final AuthService _authService = AuthService();
  bool _carregando = false;

  Future<void> _fazerLoginGoogle() async {
    if (_carregando) return;

    setState(() => _carregando = true);
    try {
      final res = await _authService.entrarComGoogle();
      if (res == null && mounted) {
        // Usuário fechou a janela do Google sem selecionar a conta
        setState(() => _carregando = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _carregando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login: $e'),
            backgroundColor: const Color(0xFFFA8772),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);
    const Color corFundo = Color(0xFFFDF4FB);

    return Scaffold(
      backgroundColor: corFundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: corRosa, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11BA149A),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  size: 60,
                  color: corRosa,
                ),
              ),

              const SizedBox(height: 32),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: corRosa,
                    height: 1.15,
                  ),
                  children: const [
                    TextSpan(text: 'Bem-vindo ao\n'),
                    TextSpan(
                      text: 'Bumbba!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Entre para salvar seu progresso e continuar suas leituras em qualquer lugar.',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                    ),
                  ),
                  onPressed: _carregando ? null : _fazerLoginGoogle,
                  child: _carregando
                      ? const CircularProgressIndicator(color: corRosa)
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 36,
                        color: corRosa,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Entrar com o Google',
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}