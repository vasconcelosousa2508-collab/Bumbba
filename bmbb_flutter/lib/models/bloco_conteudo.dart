class BlocoConteudo {
  final String tipo;
  final Map dados;

  BlocoConteudo({
    required this.tipo,
    required this.dados,
  });

  factory BlocoConteudo.fromMap(Map map) {
    return BlocoConteudo(
      tipo: map['tipo'] ?? 'texto_imagem',
      dados: map,
    );
  }
}