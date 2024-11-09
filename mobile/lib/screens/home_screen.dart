import 'package:flutter/material.dart';
import 'festa_list_screen.dart';
import 'add_festa_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Festas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FestaListScreen()),
                );
              },
              child: Text('Ver Festas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFestaScreen()),
                );
              },
              child: Text('Adicionar Festa'),
            ),
          ],
        ),
      ),
    );
  }
}
