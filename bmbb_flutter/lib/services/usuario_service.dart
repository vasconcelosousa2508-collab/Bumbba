import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Se houver usuário logado usa o UID dele, se não usa o ID de convidado
  String get _usuarioId {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return "usuario_teste_convidado";
  }

  Future<void> salvarProgresso({
    required String livroId,
    required String faixaEtaria,
    required double progresso,
  }) async {
    try {
      final String chaveHistoria = "${livroId}_$faixaEtaria";
      final String uid = _usuarioId;

      print('--> Salving progresso para $uid: $chaveHistoria = $progresso');

      await _db.collection('usuarios').doc(uid).set({
        'ultimo_acesso': FieldValue.serverTimestamp(),
        'historias_progresso': {
          chaveHistoria: progresso,
        }
      }, SetOptions(merge: true));

      print('--> Progresso salvo com sucesso no Firestore!');
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

      print('--> Concluindo história para $uid: $chaveHistoria');

      await _db.collection('usuarios').doc(uid).set({
        'ultimo_acesso': FieldValue.serverTimestamp(),
        'historias_concluidas': FieldValue.arrayUnion([chaveHistoria]),
        'historias_progresso': {
          chaveHistoria: 1.0,
        }
      }, SetOptions(merge: true));

      print('--> História concluída com sucesso no Firestore!');
    } catch (e) {
      print('--> Erro ao concluir história: $e');
    }
  }
}