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
        blocosTemp = conteudoFaixa.map((item) {
          if (item is Map) {
            return BlocoConteudo.fromMap(Map<String, dynamic>.from(item));
          } else {
            // Se algum item da lista foi salvo como String solta no banco, converte automaticamente em bloco de texto
            return BlocoConteudo.fromMap({
              'tipo': 'texto',
              'conteudo': item.toString(),
              'texto': item.toString(),
            });
          }
        }).toList();
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