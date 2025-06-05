class Mesa {
  final String id;
  final String material;
  final String forma;
  final String funcionalidad;
  final String imagenUrl;

  Mesa({
    required this.id,
    required this.material,
    required this.forma,
    required this.funcionalidad,
    required this.imagenUrl,
  });

  factory Mesa.fromMap(Map<String, dynamic> data, String id) {
    return Mesa(
      id: id,
      material: data['material'] ?? '',
      forma: data['forma'] ?? '',
      funcionalidad: data['funcionalidad'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'forma': forma,
      'funcionalidad': funcionalidad,
      'imagenUrl': imagenUrl,
    };
  }
}
