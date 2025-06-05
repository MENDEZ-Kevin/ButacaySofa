class Butaca {
  String? id;
  String material;
  String diseno;
  bool capacidadGiratoria;
  String imagenUrl;
  double precio;

  Butaca({
    this.id,
    required this.material,
    required this.diseno,
    required this.capacidadGiratoria,
    required this.imagenUrl,
    required this.precio,
  });

  factory Butaca.fromMap(Map<String, dynamic> map, {String? id}) {
    return Butaca(
      id: id,
      material: map['material'] ?? '',
      diseno: map['diseno'] ?? '',
      capacidadGiratoria: map['capacidad_giratoria'] ?? false,
      imagenUrl: map['imagenUrl'] ?? '',
      precio: (map['precio'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'diseno': diseno,
      'capacidad_giratoria': capacidadGiratoria,
      'imagenUrl': imagenUrl,
      'precio': precio,
    };
  }
}
