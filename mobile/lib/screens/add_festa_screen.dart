import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/festa.dart';
import 'festa_list_screen.dart';

class AddFestaScreen extends StatefulWidget {
  @override
  _AddFestaScreenState createState() => _AddFestaScreenState();
}

class _AddFestaScreenState extends State<AddFestaScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  void addFesta() async {
    final festa = Festa(
      id: 0, // O json-server irá gerar o ID automaticamente
      nome: nomeController.text,
      descricao: descricaoController.text,
      data: dataController.text,
    );

    try {
      await apiService.createFesta(festa);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FestaListScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar a festa: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Festa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome da Festa'),
            ),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: dataController,
              decoration: InputDecoration(labelText: 'Data (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addFesta,
              child: Text('Salvar Festa'),
            ),
          ],
        ),
      ),
    );
  }
}
