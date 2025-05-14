import 'package:flutter/material.dart';
import '../models/product.dart';
import 'form_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  String searchTerm = '';

  void _addOrUpdateProduct(Product product, [int? index]) {
    setState(() {
      if (index == null) {
        products.add(product);
      } else {
        products[index] = product;
      }
    });
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmar'),
        content: Text('Tem certeza que deseja excluir este produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() => products.removeAt(index));
              Navigator.pop(context);
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToForm([Product? product, int? index]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormScreen(product: product),
      ),
    );

    if (result != null && result is Product) {
      _addOrUpdateProduct(result, index);
    }
  }

  List<Product> _filteredProducts() {
    return products
        .where((p) => p.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  void _adjustQuantity(int index, int change) {
    setState(() {
      products[index].quantity += change;
      if (products[index].quantity < 0) products[index].quantity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Estoque Fácil', style: TextStyle(fontSize: 30)),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StatsScreen(products: products),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () => _navigateToForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Buscar produto...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                  hintStyle: TextStyle(fontSize: 20)),
              onChanged: (val) => setState(() => searchTerm = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, index) {
                final product = filtered[index];
                final realIndex = products.indexOf(product);
                return Card(
                  child: ListTile(
                    title: Text(product.name, style: TextStyle(fontSize: 20)),
                    subtitle: Text(
                        'Qtd: ${product.quantity} • ${product.description}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _adjustQuantity(realIndex, -1),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _adjustQuantity(realIndex, 1),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _navigateToForm(product, realIndex),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteProduct(realIndex),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
