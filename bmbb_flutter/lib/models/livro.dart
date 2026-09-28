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

  factory Livro.fromFirestore(
      String id,
      Map data, {
        String faixaEtaria = '1 a 3',
      }) {
    final String chaveFirestore = faixaEtaria.replaceAll(' a ', '-');

    String historiaTexto = '';
    final rawHistoria = data['historia'];

    if (rawHistoria is Map) {
      historiaTexto = rawHistoria[chaveFirestore]?.toString() ?? '';
    } else if (rawHistoria is String) {
      historiaTexto = rawHistoria;
    }

    return Livro(
      id: id,
      titulo: data['titulo'] ?? '',
      historia: historiaTexto,
      capaUrl: data['capaUrl'] ?? '',
    );
  }
}