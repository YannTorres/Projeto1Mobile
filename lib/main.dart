import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(EstoqueFacilApp());
}

class EstoqueFacilApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estoque Fácil',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
