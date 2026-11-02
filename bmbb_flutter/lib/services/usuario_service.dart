import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Salva o progresso dinâmico (ex: 0.5 para 50%)
  Future<void> salvarProgresso({
    required String livroId,
    required String faixaEtaria,
    required double progresso,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final String chaveHistoria = "${livroId}_$faixaEtaria";

    await _db.collection('usuarios').doc(user.uid).set({
      'historias_progresso': {
        chaveHistoria: progresso,
      }
    }, SetOptions(merge: true));
  }

  // Registra a história como concluída e fixa o progresso em 100%
  Future<void> concluirHistoria({
    required String livroId,
    required String faixaEtaria,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final String chaveHistoria = "${livroId}_$faixaEtaria";

    await _db.collection('usuarios').doc(user.uid).set({
      'historias_concluidas': FieldValue.arrayUnion([chaveHistoria]),
      'historias_progresso': {
        chaveHistoria: 1.0,
      }
    }, SetOptions(merge: true));
  }
}