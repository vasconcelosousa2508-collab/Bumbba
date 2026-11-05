import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Obter o usuário atualmente logado (ou null)
  User? get usuarioAtual => _auth.currentUser;

  // Stream que escuta as mudanças de estado (logado / deslogado)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Método de Login com Google
  Future<UserCredential?> entrarComGoogle() async {
    try {
      // 1. Abre a janela nativa do Google para o usuário escolher a conta
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Usuário cancelou a seleção da conta
        return null;
      }

      // 2. Obtém os tokens de autenticação da conta Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Cria a credencial para o Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Faz login no Firebase com a credencial
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // 5. Se for o primeiro acesso, cria a estrutura básica do usuário no Firestore
      if (user != null) {
        final docRef = _db.collection('usuarios').doc(user.uid);
        final docSnap = await docRef.get();

        if (!docSnap.exists) {
          await docRef.set({
            'nome': user.displayName ?? 'Usuário',
            'email': user.email ?? '',
            'fotoUrl': user.photoURL ?? '',
            'criado_em': FieldValue.serverTimestamp(),
            'ultimo_acesso': FieldValue.serverTimestamp(),
            'historias_concluidas': [],
            'historias_progresso': {},
          });
        } else {
          // Atualiza apenas a data do último acesso
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

  // Método para Sair (Logout)
  Future<void> sair() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}