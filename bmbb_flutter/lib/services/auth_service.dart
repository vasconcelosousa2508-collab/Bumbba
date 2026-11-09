import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get usuarioAtual => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> entrarComGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final docRef = _db.collection('usuarios').doc(user.uid);
        final docSnap = await docRef.get();

        if (!docSnap.exists) {
          await docRef.set({
            // Dados da Conta do Pai/Mãe (Login Google)
            'email_responsavel': user.email ?? '',
            'nome_responsavel': user.displayName ?? 'Responsável',
            'foto_responsavel': user.photoURL ?? '',
            'criado_em': FieldValue.serverTimestamp(),
            'ultimo_acesso': FieldValue.serverTimestamp(),
            'onboarding_concluido': false, // Flag crucial para acionar as telas infantis
            'historias_concluidas': [],
            'historias_progresso': {},

            /*
            ===================================================================
            'nome': user.displayName ?? 'Usuário',
            'email': user.email ?? '',
            'fotoUrl': user.photoURL ?? '',
            ===================================================================
            */
          });
        } else {
          await docRef.set({
            'ultimo_acesso': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }

      return userCredential;
    } catch (e) {
      print('--> Erro no login com Google: $e');
      rethrow;
    }
  }

  Future<void> sair() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}