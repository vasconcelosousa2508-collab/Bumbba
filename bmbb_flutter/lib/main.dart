import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'options/firebase_options.dart'; // Se estiver na pasta 'lib/'
import 'screens/tela_biblioteca.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaBiblioteca(),
    );
  }
}