import 'package:flutter/material.dart';
import '../models/product.dart';

class FormScreen extends StatefulWidget {
  final Product? product;

  FormScreen({this.product});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _quantityController =
        TextEditingController(text: widget.product?.quantity.toString() ?? '0');
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text,
        description: _descriptionController.text,
        quantity: int.tryParse(_quantityController.text) ?? 0,
      );
      Navigator.pop(context, product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Novo Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  final n = int.tryParse(val ?? '');
                  return (n == null || n < 0)
                      ? 'Informe uma quantidade válida'
                      : null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
