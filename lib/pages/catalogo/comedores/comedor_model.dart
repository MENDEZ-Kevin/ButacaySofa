class Comedor {
  final String id;
  final String material;
  final String tipoMesa;
  final int capacidadPersonas;
  final String imagenUrl;
  double precio;

  Comedor({
    required this.id,
    required this.material,
    required this.tipoMesa,
    required this.capacidadPersonas,
    required this.imagenUrl,
    required this.precio,
  });

  factory Comedor.fromMap(Map<String, dynamic> data, String id) {
    return Comedor(
      id: id,
      material: data['material'] ?? '',
      tipoMesa: data['tipo_mesa'] ?? '',
      capacidadPersonas: data['capacidad_personas'] ?? 0,
      imagenUrl: data['imagenUrl'] ?? '',
      precio: (data['precio'] != null) ? (data['precio'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'tipo_mesa': tipoMesa,
      'capacidad_personas': capacidadPersonas,
      'imagenUrl': imagenUrl,
      'precio': precio,
    };
  }
}
