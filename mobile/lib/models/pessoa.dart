class Pessoa {
  final int id;
  final int festaId;
  final String nome;
  final String contribuicao;

  Pessoa({required this.id, required this.festaId, required this.nome, required this.contribuicao});

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: int.parse(json['id'].toString()),       // Converte para int
      festaId: int.parse(json['festaId'].toString()), // Converte para int
      nome: json['nome'],
      contribuicao: json['contribuicao'],
    );
  }
}
