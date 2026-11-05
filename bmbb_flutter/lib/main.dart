import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'services/auth_service.dart';
import 'screens/tela_login.dart';
import 'screens/tela_principal.dart'; // <--- Import atualizado aqui

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitura Infantil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Se tiver usuário logado, abre a TelaPrincipal (que inicia na Biblioteca)
          if (snapshot.hasData) {
            return const TelaPrincipal(); // <--- Alterado de TelaBiblioteca para TelaPrincipal
          }

          return const TelaLogin();
        },
      ),
    );
  }
}