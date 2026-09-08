class Livro {
  final String id;
  final String titulo;
  final String historia;

  Livro({
    required this.id,
    required this.titulo,
    required this.historia,
  });

  factory Livro.fromFirestore(String id, Map<String, dynamic> data) {
    return Livro(
      id: id,
      titulo: data['titulo'] ?? '',
      historia: data['historia'] ?? '',
    );
  }
}