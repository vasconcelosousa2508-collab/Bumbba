import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tela_idade_crianca.dart';

class TelaNomeCrianca extends StatefulWidget {
  const TelaNomeCrianca({super.key});

  @override
  State<TelaNomeCrianca> createState() => _TelaNomeCriancaState();
}

class _TelaNomeCriancaState extends State<TelaNomeCrianca> {
  final TextEditingController _nomeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _avancar() {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, digite o nome da criança.',
            style: GoogleFonts.fredoka(),
          ),
          backgroundColor: const Color(0xFFBA149A),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaIdadeCrianca(nomeCrianca: _nomeController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);
    const Color corFundo = Color(0xFFFDF4FB);

    return Scaffold(
      backgroundColor: corFundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Image.asset(
                'assets/login/bumbba-head.png',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'Qual o nome da\nsua criança?',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: corRosa,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nomeController,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _avancar(),
                style: GoogleFonts.fredoka(fontSize: 20, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Digite um nome',
                  hintStyle: GoogleFonts.fredoka(color: Colors.black38),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: corRosa, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: corRosa, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corRosa,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _avancar,
                  child: Text(
                    'Continuar',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}