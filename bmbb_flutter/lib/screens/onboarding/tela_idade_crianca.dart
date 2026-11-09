import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../tela_principal.dart';

class TelaIdadeCrianca extends StatefulWidget {
  final String nomeCrianca;

  const TelaIdadeCrianca({super.key, required this.nomeCrianca});

  @override
  State<TelaIdadeCrianca> createState() => _TelaIdadeCriancaState();
}

class _TelaIdadeCriancaState extends State<TelaIdadeCrianca> {
  // Gera a lista de idades exatas de 1 a 10
  final List<int> _idades = List.generate(10, (i) => i + 1);
  int _idadeSelecionada = 4; // Valor inicial padrão (4 anos)
  bool _salvando = false;

  Future<void> _concluirCadastro() async {
    setState(() => _salvando = true);
    try {
      final user = AuthService().usuarioAtual;
      if (user != null) {
        await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
          'nome_crianca': widget.nomeCrianca,
          'idade_crianca': _idadeSelecionada,
          'onboarding_concluido': true,
        }, SetOptions(merge: true));
      }

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TelaPrincipal()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);
    const Color corFundo = Color(0xFFFDF4FB);

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: corRosa),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Imagem da cabeça do Boi Bumbá (assets/login/bumbba-head.png)
              Image.asset(
                'assets/login/bolo.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 26),

              Text(
                'Qual a idade da\nsua criança?',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: corRosa,
                  height: 1.2,
                ),
              ),

              const Spacer(),

              // Seletor roleta (CupertinoPicker) de 1 a 10 anos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    width: 100,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: _idades.indexOf(_idadeSelecionada),
                      ),
                      itemExtent: 60,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _idadeSelecionada = _idades[index];
                        });
                      },
                      children: _idades.map((idade) {
                        return Center(
                          child: Text(
                            '$idade',
                            style: GoogleFonts.fredoka(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: corRosa,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ANOS',
                    style: GoogleFonts.fredoka(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: corRosa,
                    ),
                  ),
                ],
              ),

              const Spacer(),

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
                  onPressed: _salvando ? null : _concluirCadastro,
                  child: _salvando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Concluir',
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