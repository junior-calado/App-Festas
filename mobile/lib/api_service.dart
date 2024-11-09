import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'models/festa.dart';
import 'models/pessoa.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:3000';

  int generateId() {
    return Random().nextInt(100000);
  }

  Future<List<Festa>> fetchFestas() async {
    final response = await http.get(Uri.parse('$baseUrl/festas'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((festa) => Festa.fromJson(festa)).toList();
    } else {
      throw Exception('Failed to load festas');
    }
  }

  Future<void> createFesta(Festa festa) async {
    final response = await http.post(
      Uri.parse('$baseUrl/festas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': generateId(),
        'nome': festa.nome,
        'descricao': festa.descricao,
        'data': festa.data,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create festa');
    }
  }

  Future<List<Pessoa>> fetchPessoasByFesta(int festaId) async {
    final response = await http.get(Uri.parse('$baseUrl/pessoas?festaId=$festaId'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((pessoa) => Pessoa.fromJson(pessoa)).toList();
    } else {
      throw Exception('Failed to load pessoas');
    }
  }

  Future<void> addPessoa(Pessoa pessoa) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pessoas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': generateId(),
        'festaId': pessoa.festaId,
        'nome': pessoa.nome,
        'contribuicao': pessoa.contribuicao,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add pessoa');
    }
  }

  Future<void> deleteFesta(int festaId) async {
    try {
      print('Iniciando exclusão em cascata para a festa com ID: $festaId');

      // Buscar todas as pessoas associadas à festa
      final pessoasResponse = await http.get(Uri.parse('$baseUrl/pessoas?festaId=$festaId'));
      if (pessoasResponse.statusCode == 200) {
        List<dynamic> pessoasData = json.decode(pessoasResponse.body);
        
        // Excluir cada pessoa associada à festa
        for (var pessoa in pessoasData) {
          final pessoaId = pessoa['id'];
          print('Excluindo pessoa com ID: $pessoaId associada à festa $festaId');
          await deletePessoa(pessoaId);
        }
      } else {
        throw Exception('Falha ao carregar pessoas para exclusão: Status ${pessoasResponse.statusCode}');
      }

      // Excluir a festa após excluir todas as pessoas associadas
      final response = await http.delete(Uri.parse('$baseUrl/festas/$festaId'));
      print('Status da resposta para exclusão de festa: ${response.statusCode}');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao excluir festa: Status ${response.statusCode}');
      }
      print('Festa com ID $festaId excluída com sucesso.');
    } catch (error) {
      print('Erro ao excluir a festa e suas pessoas associadas: $error');
      throw Exception('Erro ao excluir a festa e suas pessoas associadas: $error');
    }
  }

  Future<void> deletePessoa(int pessoaId) async {
    final response = await http.delete(Uri.parse('$baseUrl/pessoas/$pessoaId'));
    print('Status da resposta para exclusão de pessoa com ID $pessoaId: ${response.statusCode}');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao excluir pessoa com ID $pessoaId: Status ${response.statusCode}');
    }
  }
}
