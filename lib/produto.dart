import 'package:flutter/foundation.dart';

enum CategoriaProduto { alimentos, bebidas, limpeza, outros }

class Produto {
  int identificador;
  String nome;
  double preco;
  int quantidade;
  CategoriaProduto categoria;

  Produto({
    required this.identificador,
    required this.nome,
    required this.preco,
    required this.quantidade,
    required this.categoria,
  });

  // Serialização: Converte o objeto para um mapa
  Map<String, dynamic> gerarMapa() {
    return {
      'idProduto': identificador,
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
      'categoria': categoria.index,
    };
  }

  // Desserialização: Cria um objeto a partir de um mapa
  Produto.criarDeMapa(Map<String, dynamic> mapa)
      : identificador = mapa['idProduto'],
        nome = mapa['nome'],
        preco = mapa['preco'],
        quantidade = mapa['quantidade'],
        categoria = CategoriaProduto.values[mapa['categoria']];
}
