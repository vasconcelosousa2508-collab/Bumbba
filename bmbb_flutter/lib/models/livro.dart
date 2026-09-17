class Livro {
  final String id;
  final String titulo;
  final String historia;
  final String capaUrl;

  Livro({
    required this.id,
    required this.titulo,
    required this.historia,
    required this.capaUrl,
  });

  factory Livro.fromFirestore(String id, Map<String, dynamic> data) {
    return Livro(
      id: id,
      titulo: data['titulo'] ?? '',
      historia: data['historia'] ?? '',
      capaUrl: data['capaUrl'] ?? '',
    );
  }
}