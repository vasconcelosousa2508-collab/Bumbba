import 'bloco_conteudo.dart';

class Livro {
  final String id;
  final String titulo;
  final String capaUrl;
  final String historiaTexto;
  final List blocos;

  Livro({
    required this.id,
    required this.titulo,
    required this.capaUrl,
    required this.historiaTexto,
    required this.blocos,
  });

  bool get temConteudo => historiaTexto.isNotEmpty || blocos.isNotEmpty;

  factory Livro.fromFirestore(
      String id,
      Map data, {
        String faixaEtaria = '1 a 3',
      }) {
    final String chaveFirestore = faixaEtaria.replaceAll(' a ', '-');

    String textoTemp = '';
    List blocosTemp = [];

    final rawHistoria = data['historia'];

    if (rawHistoria is Map) {
      final conteudoFaixa = rawHistoria[chaveFirestore];

      if (conteudoFaixa is List) {
        blocosTemp = conteudoFaixa
            .map((item) => BlocoConteudo.fromMap(Map.from(item)))
            .toList();
      } else if (conteudoFaixa is String) {
        textoTemp = conteudoFaixa;
      }
    } else if (rawHistoria is String) {
      textoTemp = rawHistoria;
    }

    return Livro(
      id: id,
      titulo: data['titulo'] ?? '',
      capaUrl: data['capaUrl'] ?? '',
      historiaTexto: textoTemp,
      blocos: blocosTemp,
    );
  }
}