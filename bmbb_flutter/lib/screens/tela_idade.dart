import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaIdade extends StatefulWidget {
  const TelaIdade({super.key});

  @override
  State createState() => _TelaIdadeState();
}

class _TelaIdadeState extends State {
  final List _itens = ['1 a 3', '4 a 6', '7 a 10'];
  int _indexSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: corRosa),
        backgroundColor: Colors.transparent, // Garante fundo transparente
        scrolledUnderElevation: 0, // Impede que a AppBar mude de cor ao rolar a roleta
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CupertinoPicker(
                    itemExtent: 60,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _indexSelecionado = index;
                      });
                    },
                    children: _itens.map((item) {
                      return Center(
                        child: Text(
                          item,
                          style: GoogleFonts.fredoka(
                            fontSize: 36,
                            color: corRosa,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'ANOS',
                  style: GoogleFonts.fredoka(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: corRosa,
                  ),
                ),
              ],
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _itens[_indexSelecionado]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corRosa,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Selecionar Idade',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}