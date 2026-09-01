import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MinhaPrimeiraTela(),
    );
  }
}

class MinhaPrimeiraTela extends StatelessWidget {
  const MinhaPrimeiraTela({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TabBar(tabs: tabs)
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       'Histórias do Folclore',
        //       style: TextStyle(

        //         fontSize: 28,
        //         fontWeight: FontWeight.bold,
        //         color: Color(0xFFBA149A),
        //       ),
        //     ),
        //
        //     SizedBox(height: 12),
        //
        //     Text(
        //       'Escolha uma história para começar a ler.',
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: Colors.grey,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}