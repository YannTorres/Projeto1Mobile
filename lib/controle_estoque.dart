import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'produto.dart';

enum OperacaoEstoque { inclusao, alteracao }

class ControleEstoque {
  Future<String> _obterCaminhoArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return '${diretorio.path}/estoque.json';
  }

  Future<List<Produto>> obterListaProdutos() async {
    final arquivo = File(await _obterCaminhoArquivo());
    if (arquivo.existsSync()) {
      final conteudo = await arquivo.readAsString();
      final Map<String, dynamic> conteudoJson = json.decode(conteudo);
      final List<dynamic> listaJson = conteudoJson['produtos'] ?? [];
      return listaJson.map((mapa) => Produto.criarDeMapa(mapa)).toList();
    }
    return [];
  }

  Future<int> incluir(Produto produto) async {
    final produtos = await obterListaProdutos();
    produtos.add(produto);
    await _gravarProdutos(produtos);
    return 1; // Sucesso
  }

  Future<int> alterar(Produto produtoAlterado) async {
    final produtos = await obterListaProdutos();
    final index = produtos
        .indexWhere((p) => p.identificador == produtoAlterado.identificador);
    if (index != -1) {
      produtos[index] = produtoAlterado;
      await _gravarProdutos(produtos);
      return 1; // Sucesso
    }
    return 0; // Falha
  }

  Future<int> excluir(int identificador) async {
    final produtos = await obterListaProdutos();
    final index = produtos.indexWhere((p) => p.identificador == identificador);
    if (index != -1) {
      produtos.removeAt(index);
      await _gravarProdutos(produtos);
      return 1; // Sucesso
    }
    return 0; // Falha
  }

  Future<void> _gravarProdutos(List<Produto> produtos) async {
    final arquivo = File(await _obterCaminhoArquivo());
    final mapa = {
      'produtos': produtos.map((p) => p.gerarMapa()).toList(),
    };
    final conteudo = json.encode(mapa);
    await arquivo.writeAsString(conteudo);
  }
}
