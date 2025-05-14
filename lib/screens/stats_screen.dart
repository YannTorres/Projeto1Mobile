import 'package:flutter/material.dart';
import '../models/product.dart';

class StatsScreen extends StatelessWidget {
  final List<Product> products;

  StatsScreen({required this.products});

  @override
  Widget build(BuildContext context) {
    final totalItems = products.length;
    final totalQuantity = products.fold(0, (sum, p) => sum + p.quantity);
    final outOfStock = products.where((p) => p.quantity == 0).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Estatísticas')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produtos cadastrados: $totalItems',
                style: TextStyle(fontSize: 24)),
            Text('Quantidade total em estoque: $totalQuantity',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Produtos esgotados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...outOfStock.map(
              (p) => ListTile(
                title: Text(p.name),
                subtitle: Text(p.description),
              ),
            )
          ],
        ),
      ),
    );
  }
}
