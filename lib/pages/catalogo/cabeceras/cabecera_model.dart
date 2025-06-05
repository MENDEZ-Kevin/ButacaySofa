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
    return Cabecera(
      id: id,
      altura: map['altura'] ?? '',
      material: map['material'] ?? '',
      disenoDecorativo: map['diseno_decorativo'] ?? '',
      imagenUrl: map['imagenUrl'] ?? '',
      precio: (map['precio'] != null) ? (map['precio'] as num).toDouble() : 0.0,
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
}
