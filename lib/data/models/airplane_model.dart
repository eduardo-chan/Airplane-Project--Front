class Airplane {
  final String id;
  final String modelo;
  final String fabricante;
  final int capacidad;
  final String rango;

  Airplane({
    this.id = '',
    required this.modelo,
    required this.fabricante,
    required this.capacidad,
    required this.rango,
  });

  factory Airplane.fromJson(Map<String, dynamic> json) {
    return Airplane(
      id: json['id'] ?? '',
      modelo: json['modelo'],
      fabricante: json['fabricante'],
      capacidad: json['capacidad'],
      rango: json['rango'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelo': modelo,
      'fabricante': fabricante,
      'capacidad': capacidad,
      'rango': rango,
    };
  }
}
