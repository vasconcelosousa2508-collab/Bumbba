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
    setState(() => _carregando = true);
    try {
      await _authService.entrarComGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login: $e'),
            backgroundColor: const Color(0xFFFA8772),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
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

              // Logo ou Ícone lúdico de Entrada
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

              // Título com apenas "Bumbba!" em Bold
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.w400, // Peso normal para "Bem-vindo ao"
                    color: corRosa,
                    height: 1.15,
                  ),
                  children: const [
                    TextSpan(text: 'Bem-vindo ao\n'),
                    TextSpan(
                      text: 'Bumbba!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Negrito apenas aqui
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

              // Botão Entrar com Google
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
                      // Ícone do Google
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                        height: 24,
                        width: 24,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.g_mobiledata, size: 30, color: corRosa),
                      ),
                      const SizedBox(width: 12),
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
