import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(FestaApp());
}

class FestaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Festas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
