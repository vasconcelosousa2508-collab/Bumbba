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
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Usuário autenticado no Firebase Auth
          if (authSnapshot.hasData && authSnapshot.data != null) {
            final user = authSnapshot.data!;

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, docSnapshot) {
                if (docSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                // Se o documento no Firestore ainda não existir (criando no login), aguarda
                if (!docSnapshot.hasData || !docSnapshot.data!.exists) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final data = docSnapshot.data!.data() as Map<String, dynamic>?;
                final bool onboardingConcluido = data?['onboarding_concluido'] ?? false;

                if (!onboardingConcluido) {
                  return const TelaNomeCrianca();
                }

                return const TelaPrincipal();
              },
            );
          }

          // Sem usuário autenticado
          return const TelaLogin();
        },
      ),
    );
  }
}