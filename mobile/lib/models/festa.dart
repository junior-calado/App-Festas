class Festa {
  final int id;
  final String nome;
  final String descricao;
  final String data;

  Festa({required this.id, required this.nome, required this.descricao, required this.data});

  factory Festa.fromJson(Map<String, dynamic> json) {
    return Festa(
      id: int.parse(json['id'].toString()), // Converte para int
      nome: json['nome'],
      descricao: json['descricao'],
      data: json['data'],
    );
  }
}
