class Cabecera {
  String? id;
  String altura;
  String material;
  String disenoDecorativo;
  String imagenUrl;
  double precio; // ✅ Nuevo campo

  Cabecera({
    this.id,
    required this.altura,
    required this.material,
    required this.disenoDecorativo,
    required this.imagenUrl,
    required this.precio, // ✅ Añadido al constructor
  });

  factory Cabecera.fromMap(Map<String, dynamic> map, String id) {
    return Cabecera(
      id: id,
      altura: map['altura'] ?? '',
      material: map['material'] ?? '',
      disenoDecorativo: map['diseno_decorativo'] ?? '',
      imagenUrl: map['imagenUrl'] ?? '',
      precio: (map['precio'] != null)
          ? (map['precio'] as num).toDouble()
          : 0.0, // ✅ Conversión segura
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'altura': altura,
      'material': material,
      'diseno_decorativo': disenoDecorativo,
      'imagenUrl': imagenUrl,
      'precio': precio, // ✅ Incluir en el mapa
    };
  }
}
