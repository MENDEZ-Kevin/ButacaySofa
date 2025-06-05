class Comedor {
  final String id;
  final String material;
  final String tipoMesa;
  final int capacidadPersonas;
  final String imagenUrl;

  Comedor({
    required this.id,
    required this.material,
    required this.tipoMesa,
    required this.capacidadPersonas,
    required this.imagenUrl,
  });

  factory Comedor.fromMap(Map<String, dynamic> data, String id) {
    return Comedor(
      id: id,
      material: data['material'] ?? '',
      tipoMesa: data['tipo_mesa'] ?? '',
      capacidadPersonas: data['capacidad_personas'] ?? 0,
      imagenUrl: data['imagenUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'tipo_mesa': tipoMesa,
      'capacidad_personas': capacidadPersonas,
      'imagenUrl': imagenUrl,
    };
  }
}
