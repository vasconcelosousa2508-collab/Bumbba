import 'package:flutter_test/flutter_test.dart';

import 'package:bmbb_flutter/models/livro.dart';

void main() {
  group('Livro.fromFirestore ordenação de blocos', () {
    test('posiciona ordem numérica entre blocos sem ordem explícita', () {
      final livro = Livro.fromFirestore('livro-1', {
        'historia': {
          '1-3': [
            {'tipo': 'texto_imagem', 'texto': 'bloco 0'},
            {'tipo': 'texto_imagem', 'texto': 'bloco 1'},
            {'tipo': 'texto_imagem', 'texto': 'bloco 2', 'ordem': 15},
            {'tipo': 'texto_imagem', 'texto': 'bloco 3'},
          ],
        },
      });

      expect(livro.blocos.map((bloco) => bloco.dados['texto']).toList(), [
        'bloco 0',
        'bloco 1',
        'bloco 2',
        'bloco 3',
      ]);
    });

    test('interpreta ordem numérica armazenada como texto', () {
      final livro = Livro.fromFirestore('livro-1', {
        'historia': {
          '1-3': [
            {'tipo': 'texto_imagem', 'texto': 'bloco 0'},
            {'tipo': 'texto_imagem', 'texto': 'bloco 1'},
            {'tipo': 'texto_imagem', 'texto': 'bloco 2', 'ordem': '15'},
            {'tipo': 'texto_imagem', 'texto': 'bloco 3'},
          ],
        },
      });

      expect(livro.blocos.map((bloco) => bloco.dados['texto']).toList(), [
        'bloco 0',
        'bloco 1',
        'bloco 2',
        'bloco 3',
      ]);
    });

    test('preserva a ordem original quando dois blocos têm o mesmo peso', () {
      final livro = Livro.fromFirestore('livro-1', {
        'historia': {
          '1-3': [
            {'tipo': 'texto_imagem', 'texto': 'primeiro', 'ordem': 10},
            {'tipo': 'texto_imagem', 'texto': 'segundo', 'ordem': 10},
          ],
        },
      });

      expect(livro.blocos.map((bloco) => bloco.dados['texto']).toList(), [
        'primeiro',
        'segundo',
      ]);
    });
  });
}
