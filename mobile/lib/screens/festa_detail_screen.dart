import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/festa.dart';
import '../models/pessoa.dart';

class FestaDetailScreen extends StatefulWidget {
  final Festa festa;

  FestaDetailScreen({required this.festa});

  @override
  _FestaDetailScreenState createState() => _FestaDetailScreenState();
}

class _FestaDetailScreenState extends State<FestaDetailScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController nomePessoaController = TextEditingController();
  final TextEditingController contribuicaoController = TextEditingController();
  List<Pessoa> pessoas = [];

  @override
  void initState() {
    super.initState();
    fetchPessoas();
  }

  void fetchPessoas() async {
    try {
      List<Pessoa> fetchedPessoas = await apiService.fetchPessoasByFesta(widget.festa.id);
      setState(() {
        pessoas = fetchedPessoas;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar as pessoas: $error')),
      );
    }
  }

  void addPessoa() async {
    if (nomePessoaController.text.isEmpty || contribuicaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos para adicionar uma pessoa')),
      );
      return;
    }

    final pessoa = Pessoa(
      id: 0,
      festaId: widget.festa.id,
      nome: nomePessoaController.text,
      contribuicao: contribuicaoController.text,
    );

    try {
      await apiService.addPessoa(pessoa);
      nomePessoaController.clear();
      contribuicaoController.clear();
      fetchPessoas();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar pessoa: $error')),
      );
    }
  }

  void deletePessoa(int pessoaId) async {
  print('Tentando excluir a pessoa com ID: $pessoaId');
  try {
    await apiService.deletePessoa(pessoaId);
    fetchPessoas(); // Recarrega a lista após exclusão
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pessoa excluída com sucesso')),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao excluir pessoa: $error')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.festa.nome),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${widget.festa.descricao}'),
            Text('Data: ${widget.festa.data}'),
            SizedBox(height: 20),
            Text('Pessoas na Festa:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: pessoas.isEmpty
                  ? Text('Nenhuma pessoa cadastrada nesta festa')
                  : ListView.builder(
                      itemCount: pessoas.length,
                      itemBuilder: (context, index) {
                        final pessoa = pessoas[index];
                        return ListTile(
                          title: Text(pessoa.nome),
                          subtitle: Text('Contribuição: ${pessoa.contribuicao}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deletePessoa(pessoa.id);
                            },
                          ),
                        );
                      },
                    ),
            ),
            TextField(
              controller: nomePessoaController,
              decoration: InputDecoration(labelText: 'Nome da Pessoa'),
            ),
            TextField(
              controller: contribuicaoController,
              decoration: InputDecoration(labelText: 'Contribuição'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addPessoa,
              child: Text('Adicionar Pessoa'),
            ),
          ],
        ),
      ),
    );
  }
}
