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

  Future<Set<int>> carregarAtividadesConcluidas({
    required String livroId,
    required String faixaEtaria,
  }) async {
    try {
      final String chaveHistoria = "${livroId}_$faixaEtaria";
      final doc = await _db.collection('usuarios').doc(_usuarioId).get();
      if (!doc.exists) return {};

      final data = doc.data();
      final mapaAtividades = data?['atividades_concluidas'];
      if (mapaAtividades is Map && mapaAtividades[chaveHistoria] is List) {
        final lista = mapaAtividades[chaveHistoria] as List;
        return lista.map((e) => int.parse(e.toString())).toSet();
      }
      return {};
    } catch (e) {
      print('--> Erro ao carregar atividades concluídas: $e');
      return {};
    }
  }

  Future<void> salvarProgresso({
    required String livroId,
    required String faixaEtaria,
    required double progresso,
    required Set<int> atividadesConcluidas,
  }) async {
    try {
      final String chaveHistoria = "${livroId}_$faixaEtaria";
      final String uid = _usuarioId;

      await _db.collection('usuarios').doc(uid).set({
        'ultimo_acesso': FieldValue.serverTimestamp(),
        'historias_progresso': {
          chaveHistoria: progresso,
        },
        'atividades_concluidas': {
          chaveHistoria: atividadesConcluidas.toList(),
        },
      }, SetOptions(merge: true));
    } catch (e) {
      print('--> Erro ao salvar progresso: $e');
    }
  }

  Future<void> concluirHistoria({
    required String livroId,
    required String faixaEtaria,
    required Set<int> atividadesConcluidas,
  }) async {
    try {
      final String chaveHistoria = "${livroId}_$faixaEtaria";
      final String uid = _usuarioId;

      await _db.collection('usuarios').doc(uid).set({
        'ultimo_acesso': FieldValue.serverTimestamp(),
        'historias_concluidas': FieldValue.arrayUnion([chaveHistoria]),
        'historias_progresso': {
          chaveHistoria: 1.0,
        },
        'atividades_concluidas': {
          chaveHistoria: atividadesConcluidas.toList(),
        },
      }, SetOptions(merge: true));
    } catch (e) {
      print('--> Erro ao concluir história: $e');
    }
  }
}