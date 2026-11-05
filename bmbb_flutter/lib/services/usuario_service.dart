import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _usuarioId {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    throw Exception("Nenhum usuário logado ao tentar salvar dados no Firestore.");
  }

  Future<void> salvarProgresso({
    required String livroId,
    required String faixaEtaria,
    required double progresso,
  }) async {
    try {
      final String chaveHistoria = "${livroId}_$faixaEtaria";
      final String uid = _usuarioId;

      await _db.collection('usuarios').doc(uid).set({
        'ultimo_acesso': FieldValue.serverTimestamp(),
        'historias_progresso': {
          chaveHistoria: progresso,
        }
      }, SetOptions(merge: true));

      print('--> Progresso salvo com sucesso para o UID: $uid');
    } catch (e) {
      print('--> Erro ao salvar progresso: $e');
    }
  }

  Future<void> concluirHistoria({
    required String livroId,
    required String faixaEtaria,
  }) async {
    try {
      final String chaveHistoria = "${livroId}_$faixaEtaria";
      final String uid = _usuarioId;

      await _db.collection('usuarios').doc(uid).set({
        'ultimo_acesso': FieldValue.serverTimestamp(),
        'historias_concluidas': FieldValue.arrayUnion([chaveHistoria]),
        'historias_progresso': {
          chaveHistoria: 1.0,
        }
      }, SetOptions(merge: true));

      print('--> História concluída com sucesso para o UID: $uid');
    } catch (e) {
      print('--> Erro ao concluir história: $e');
    }
  }
}