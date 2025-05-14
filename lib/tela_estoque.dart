import 'package:flutter/material.dart';
import 'controle_estoque.dart';
import 'produto.dart';

class TelaEstoque extends StatefulWidget {
  const TelaEstoque({super.key});

  @override
  _TelaEstoqueState createState() => _TelaEstoqueState();
}

class _TelaEstoqueState extends State<TelaEstoque> {
  final _controleEstoque = ControleEstoque();

  Widget _criarItem(BuildContext context, Produto produto) {
    return Dismissible(
      key: Key(produto.identificador.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        final resultado = await _controleEstoque.excluir(produto.identificador);
        if (resultado > 0) {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produto excluído com sucesso.')),
          );
        }
      },
      child: ListTile(
        title: Text(
          produto.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preço: R\$${produto.preco.toStringAsFixed(2)}'),
            Text('Quantidade: ${produto.quantidade}'),
            Text('Categoria: ${produto.categoria.toString().split('.').last}'),
          ],
        ),
        onTap: () => _executarOperacaoCadastro(
            context, OperacaoEstoque.alteracao, produto),
      ),
    );
  }

  Widget _criarVisualizadorLista(BuildContext context, List<Produto> produtos) {
    return ListView.separated(
      itemCount: produtos.length,
      itemBuilder: (context, index) => _criarItem(context, produtos[index]),
      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
    );
  }

  Widget _criarListaProdutos() {
    return FutureBuilder(
      future: _controleEstoque.obterListaProdutos(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<Produto> && snapshot.data.isNotEmpty) {
            return _criarVisualizadorLista(context, snapshot.data);
          } else {
            return const Center(child: Text('Nenhum produto cadastrado.'));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<bool> _executarOperacaoCadastro(
      BuildContext context, OperacaoEstoque operacao, Produto produto) async {
    final produtoRetornado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCadastroProduto(operacao, produto),
      ),
    );
    if (produtoRetornado != null) {
      int resultado;
      if (operacao == OperacaoEstoque.inclusao) {
        resultado = await _controleEstoque.incluir(produtoRetornado);
      } else {
        resultado = await _controleEstoque.alterar(produtoRetornado);
      }
      if (resultado > 0) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(operacao == OperacaoEstoque.inclusao
                ? 'Inclusão realizada com sucesso.'
                : 'Alteração realizada com sucesso.'),
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Operação não realizada.')),
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Estoque'),
        centerTitle: true,
      ),
      body: _criarListaProdutos(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _executarOperacaoCadastro(
          context,
          OperacaoEstoque.inclusao,
          Produto(
            identificador: DateTime.now().millisecondsSinceEpoch,
            nome: '',
            preco: 0.0,
            quantidade: 0,
            categoria: CategoriaProduto.outros,
          ),
        ),
      ),
    );
  }
}

class TelaCadastroProduto extends StatefulWidget {
  final OperacaoEstoque operacao;
  final Produto produto;

  const TelaCadastroProduto(this.operacao, this.produto, {super.key});

  @override
  _TelaCadastroProdutoState createState() => _TelaCadastroProdutoState();
}

class _TelaCadastroProdutoState extends State<TelaCadastroProduto> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _precoController;
  late TextEditingController _quantidadeController;
  late CategoriaProduto _categoria;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto.nome);
    _precoController =
        TextEditingController(text: widget.produto.preco.toString());
    _quantidadeController =
        TextEditingController(text: widget.produto.quantidade.toString());
    _categoria = widget.produto.categoria;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.operacao == OperacaoEstoque.inclusao
            ? 'Novo Produto'
            : 'Editar Produto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value!.isEmpty ? 'Nome é obrigatório' : null,
              ),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Preço é obrigatório';
                  if (double.tryParse(value) == null) return 'Preço inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Quantidade é obrigatória';
                  if (int.tryParse(value) == null) return 'Quantidade inválida';
                  return null;
                },
              ),
              DropdownButtonFormField<CategoriaProduto>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: CategoriaProduto.values
                    .map((categoria) => DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria.toString().split('.').last),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _categoria = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final produto = Produto(
                      identificador: widget.produto.identificador,
                      nome: _nomeController.text,
                      preco: double.parse(_precoController.text),
                      quantidade: int.parse(_quantidadeController.text),
                      categoria: _categoria,
                    );
                    Navigator.pop(context, produto);
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
