import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaSelecionarAvatar extends StatefulWidget {
  final String uid;
  final String? avatarIdAtual;

  const TelaSelecionarAvatar({
    super.key,
    required this.uid,
    this.avatarIdAtual,
  });

  @override
  State<TelaSelecionarAvatar> createState() => _TelaSelecionarAvatarState();
}

class _TelaSelecionarAvatarState extends State<TelaSelecionarAvatar> {
  String? _idSelecionado;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _idSelecionado = widget.avatarIdAtual;
  }

  Future<void> _salvarAvatar() async {
    if (_idSelecionado == null || _idSelecionado!.isEmpty) {
      Navigator.pop(context);
      return;
    }

    setState(() => _salvando = true);

    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.uid)
          .set({'avatar_id': _idSelecionado}, SetOptions(merge: true));

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _salvando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar avatar. Tente novamente.',
              style: GoogleFonts.fredoka(),
            ),
            backgroundColor: const Color(0xFFFA8772),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color corRosa = Color(0xFFBA149A);
    const Color corFundo = Color(0xFFFDF4FB);

    return Scaffold(
      backgroundColor: corFundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: corRosa,
                  size: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('avatar').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar os avatares.',
                          style: GoogleFonts.fredoka(color: Colors.black54, fontSize: 16),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: corRosa));
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhum avatar disponível.',
                          style: GoogleFonts.fredoka(color: Colors.black54, fontSize: 16),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final String id = doc.id;
                        final data = doc.data() as Map<String, dynamic>;
                        final String url = data['url'] ?? '';
                        final bool estaSelecionado = _idSelecionado == id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _idSelecionado = id;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: estaSelecionado
                                  ? corRosa.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x18000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: const Color(0xFFD9D9D9),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFFD9D9D9),
                                    child: const Icon(Icons.person, color: corRosa, size: 42),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corRosa,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _salvando ? null : _salvarAvatar,
                  child: _salvando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Selecionar',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}