import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'dart:convert';

import '../lib/api_service.dart';
import '../lib/models/festa.dart';
import '../lib/models/pessoa.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ApiService apiService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    apiService = ApiService();
  });

  group('fetchFestas', () {
    test('returns a list of festas if the http call completes successfully', () async {
      when(mockClient.get(Uri.parse('http://127.0.0.1:3000/festas')))
          .thenAnswer((_) async => http.Response(
              '[{"id": 1, "nome": "Festa A", "descricao": "Descricao A", "data": "2023-12-25"}]', 200));

      final festas = await apiService.fetchFestas();

      expect(festas, isA<List<Festa>>());
      expect(festas[0].nome, 'Festa A');
    });

    test('throws an exception if the http call completes with an error', () {
      when(mockClient.get(Uri.parse('http://127.0.0.1:3000/festas')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(apiService.fetchFestas(), throwsException);
    });
  });

  group('createFesta', () {
    test('sends a POST request to create a festa', () async {
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:3000/festas'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 201));

      final festa = Festa(id: 1, nome: 'Festa B', descricao: 'Descricao B', data: '2023-12-31');
      await apiService.createFesta(festa);

      verify(mockClient.post(
        Uri.parse('http://127.0.0.1:3000/festas'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': any,
          'nome': 'Festa B',
          'descricao': 'Descricao B',
          'data': '2023-12-31',
        }),
      ));
    });

    test('throws an exception if the POST request fails', () {
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:3000/festas'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Bad Request', 400));

      final festa = Festa(id: 1, nome: 'Festa B', descricao: 'Descricao B', data: '2023-12-31');

      expect(apiService.createFesta(festa), throwsException);
    });
  });

  group('fetchPessoasByFesta', () {
    test('returns a list of pessoas associated with a festa', () async {
      when(mockClient.get(Uri.parse('http://127.0.0.1:3000/pessoas?festaId=1')))
          .thenAnswer((_) async => http.Response(
              '[{"id": 1, "festaId": 1, "nome": "João", "contribuicao": 50.0}]', 200));

      final pessoas = await apiService.fetchPessoasByFesta(1);

      expect(pessoas, isA<List<Pessoa>>());
      expect(pessoas[0].nome, 'João');
    });

    test('throws an exception if the http call completes with an error', () {
      when(mockClient.get(Uri.parse('http://127.0.0.1:3000/pessoas?festaId=1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(apiService.fetchPessoasByFesta(1), throwsException);
    });
  });

  group('addPessoa', () {
    test('sends a POST request to add a pessoa', () async {
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:3000/pessoas'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 201));

      final pessoa = Pessoa(id: 1, festaId: 1, nome: 'Maria', contribuicao: "Pao");
      await apiService.addPessoa(pessoa);

      verify(mockClient.post(
        Uri.parse('http://127.0.0.1:3000/pessoas'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': any,
          'festaId': 1,
          'nome': 'Maria',
          'contribuicao': 30.0,
        }),
      ));
    });

    test('throws an exception if the POST request fails', () {
      when(mockClient.post(
        Uri.parse('http://127.0.0.1:3000/pessoas'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Bad Request', 400));

      final pessoa = Pessoa(id: 1, festaId: 1, nome: 'Maria', contribuicao: "Pao");

      expect(apiService.addPessoa(pessoa), throwsException);
    });
  });

  group('deleteFesta', () {
    test('deletes a festa and its associated pessoas', () async {
      when(mockClient.get(Uri.parse('http://127.0.0.1:3000/pessoas?festaId=1')))
          .thenAnswer((_) async => http.Response(
              '[{"id": 1, "festaId": 1, "nome": "João", "contribuicao": 50.0}]', 200));
      when(mockClient.delete(Uri.parse('http://127.0.0.1:3000/pessoas/1')))
          .thenAnswer((_) async => http.Response('', 204));
      when(mockClient.delete(Uri.parse('http://127.0.0.1:3000/festas/1')))
          .thenAnswer((_) async => http.Response('', 204));

      await apiService.deleteFesta(1);

      verify(mockClient.delete(Uri.parse('http://127.0.0.1:3000/festas/1'))).called(1);
    });

    test('throws an exception if deleting festa fails', () async {
      when(mockClient.delete(Uri.parse('http://127.0.0.1:3000/festas/1')))
          .thenAnswer((_) async => http.Response('Error', 400));

      expect(apiService.deleteFesta(1), throwsException);
    });
  });
}
