class Comedor {
  final String id;
  final String material;
  final String tipoMesa;
  final int capacidadPersonas;
  final double precio;
  final String imagenUrl;

  Comedor({
    required this.id,
    required this.material,
    required this.tipoMesa,
    required this.capacidadPersonas,
    required this.precio,
    required this.imagenUrl,
  });

  factory Comedor.fromMap(Map<String, dynamic> data, String id) {
    return Comedor(
      id: id,
      material: data['material'] ?? '',
      tipoMesa: data['tipo_mesa'] ?? '',
      capacidadPersonas: data['capacidad_personas'] ?? 0,
      precio: (data['precio'] is int)
          ? (data['precio'] as int).toDouble()
          : (data['precio'] ?? 0.0),
      imagenUrl: data['imagenUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'tipo_mesa': tipoMesa,
      'capacidad_personas': capacidadPersonas,
      'precio': precio,
      'imagenUrl': imagenUrl,
    };
  }
}
