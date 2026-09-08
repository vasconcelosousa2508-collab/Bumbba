import 'package:flutter/material.dart';
import '../models/livro.dart';

class TelaHistoria extends StatelessWidget {
  final Livro livro;

  const TelaHistoria({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFBA149A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          livro.titulo,
          style: const TextStyle(color: Color(0xFFBA149A), fontSize: 24.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              livro.historia,
              style: const TextStyle(
                fontSize: 16.0,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}