class Cabecera {
  String? id;
  String altura;
  String material;
  String disenoDecorativo;
  String imagenUrl;
  double precio;

  Cabecera({
    this.id,
    required this.altura,
    required this.material,
    required this.disenoDecorativo,
    required this.imagenUrl,
    required this.precio,
  });

  factory Cabecera.fromMap(Map<String, dynamic> map, String id) {
    if (!map.containsKey('altura') || !map.containsKey('material') || !map.containsKey('precio')) {
      throw ArgumentError('Faltan campos obligatorios en el mapa de Cabecera');
    }

    return Cabecera(
      id: id,
      altura: map['altura'] ?? '',
      material: map['material'] ?? '',
      disenoDecorativo: map['diseno_decorativo'] ?? '',
      imagenUrl: map['imagenUrl'] ?? '',
      precio: (map['precio'] is num) ? (map['precio'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'altura': altura,
      'material': material,
      'diseno_decorativo': disenoDecorativo,
      'imagenUrl': imagenUrl,
      'precio': precio,
    };
  }

  Cabecera copyWith({
    String? id,
    String? altura,
    String? material,
    String? disenoDecorativo,
    String? imagenUrl,
    double? precio,
  }) {
    return Cabecera(
      id: id ?? this.id,
      altura: altura ?? this.altura,
      material: material ?? this.material,
      disenoDecorativo: disenoDecorativo ?? this.disenoDecorativo,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      precio: precio ?? this.precio,
    );
  }

  @override
  String toString() {
    return 'Cabecera(id: $id, altura: $altura, material: $material, diseño: $disenoDecorativo, precio: $precio)';
  }
}
