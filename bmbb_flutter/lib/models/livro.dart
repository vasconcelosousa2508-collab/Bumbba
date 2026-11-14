import 'bloco_conteudo.dart';

class Livro {
  final String id;
  final String titulo;
  final String capaUrl;
  final String historiaTexto;
  final List<BlocoConteudo> blocos;

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
    List<BlocoConteudo> blocosTemp = [];

    final rawHistoria = data['historia'];

    if (rawHistoria is Map) {
      final conteudoFaixa = rawHistoria[chaveFirestore];

      if (conteudoFaixa is List) {
        final List<MapEntry<num, BlocoConteudo>> blocosComPeso = [];

        for (int i = 0; i < conteudoFaixa.length; i++) {
          final item = conteudoFaixa[i];
          final num pesoPadrao = i * 10;

          if (item is Map) {
            final mapa = Map<String, dynamic>.from(item);
            final dynamic ordemCustom = mapa['ordem'];
            final num pesoFinal = ordemCustom is num ? ordemCustom : pesoPadrao;

            blocosComPeso.add(MapEntry(pesoFinal, BlocoConteudo.fromMap(mapa)));
          } else {
            blocosComPeso.add(
              MapEntry(
                pesoPadrao,
                BlocoConteudo.fromMap({
                  'tipo': 'texto_imagem',
                  'conteudo': item.toString(),
                  'texto': item.toString(),
                }),
              ),
            );
          }
        }

        blocosComPeso.sort((a, b) => a.key.compareTo(b.key));
        blocosTemp = blocosComPeso.map((e) => e.value).toList();
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