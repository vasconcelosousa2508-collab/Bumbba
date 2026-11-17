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
        final List<({num ordem, int indiceOriginal, BlocoConteudo bloco})>
        blocosComOrdem = [];

        for (int i = 0; i < conteudoFaixa.length; i++) {
          final item = conteudoFaixa[i];
          final num ordemPadrao = i * 10;

          if (item is Map) {
            final mapa = Map<String, dynamic>.from(item);
            final dynamic ordemBruta = mapa['ordem'];
            final num? ordemCustom = ordemBruta is num
                ? ordemBruta
                : ordemBruta is String
                ? num.tryParse(ordemBruta.trim())
                : null;
            final num ordemFinal = ordemCustom != null && ordemCustom.isFinite
                ? ordemCustom
                : ordemPadrao;

            blocosComOrdem.add((
              ordem: ordemFinal,
              indiceOriginal: i,
              bloco: BlocoConteudo.fromMap(mapa),
            ));
          } else {
            final bloco = BlocoConteudo.fromMap({
              'tipo': 'texto_imagem',
              'conteudo': item.toString(),
              'texto': item.toString(),
            });

            blocosComOrdem.add((
              ordem: ordemPadrao,
              indiceOriginal: i,
              bloco: bloco,
            ));
          }
        }

        blocosComOrdem.sort((a, b) {
          final comparacaoOrdem = a.ordem.compareTo(b.ordem);
          return comparacaoOrdem != 0
              ? comparacaoOrdem
              : a.indiceOriginal.compareTo(b.indiceOriginal);
        });
        blocosTemp = blocosComOrdem.map((item) => item.bloco).toList();
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
