import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'services/auth_service.dart';
import 'screens/tela_login.dart';
import 'screens/tela_principal.dart';
import 'screens/onboarding/tela_nome_crianca.dart';

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

          // Se tiver usuário logado, verifica no Firestore se o onboarding foi concluído
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get(),
              builder: (context, docSnapshot) {
                if (docSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final data = docSnapshot.data?.data() as Map<String, dynamic>?;
                final bool onboardingConcluido = data?['onboarding_concluido'] ?? false;

                // Se ainda NÃO concluiu o cadastro do nome/idade da criança, vai pro Onboarding
                if (!onboardingConcluido) {
                  return const TelaNomeCrianca();
                }

                // Se já concluiu, vai pra tela principal
                return const TelaPrincipal();
              },
            );
          }

          return const TelaLogin();
        },
      ),
    );
  }
}