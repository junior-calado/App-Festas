import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/festa.dart';
import 'festa_detail_screen.dart';

class FestaListScreen extends StatefulWidget {
  @override
  _FestaListScreenState createState() => _FestaListScreenState();
}

class _FestaListScreenState extends State<FestaListScreen> {
  final ApiService apiService = ApiService();
  List<Festa> festas = [];

  @override
  void initState() {
    super.initState();
    fetchFestas();
  }

  void fetchFestas() async {
    try {
      List<Festa> fetchedFestas = await apiService.fetchFestas();
      setState(() {
        festas = fetchedFestas;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar as festas: $error')),
      );
    }
  }

  void deleteFesta(int festaId) async {
    print('Tentando excluir a festa com ID: $festaId');
    try {
      await apiService.deleteFesta(festaId);
      fetchFestas(); // Recarrega a lista após exclusão
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Festa excluída com sucesso')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir a festa: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Festas'),
      ),
      body: festas.isEmpty
          ? Center(child: Text('Nenhuma festa cadastrada'))
          : ListView.builder(
              itemCount: festas.length,
              itemBuilder: (context, index) {
                final festa = festas[index];
                return ListTile(
                  title: Text(festa.nome),
                  subtitle: Text(
                      'Data: ${festa.data}\nDescrição: ${festa.descricao}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FestaDetailScreen(festa: festa),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteFesta(festa.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
