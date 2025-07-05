class Sofa {
  final String id;
  final String material;
  final int numeroPiezas;
  final String diseno;
  final String imagen;
  final double precio;

  Sofa({
    required this.id,
    required this.material,
    required this.numeroPiezas,
    required this.diseno,
    required this.imagen,
    required this.precio,
  });

  factory Sofa.fromMap(Map<String, dynamic> data, String id) {
    return Sofa(
      id: id,
      material: data['material'] ?? '',
      numeroPiezas: data['numero_piezas'] ?? 0,
      diseno: data['diseno'] ?? '',
      imagen: data['imagen'] ?? '',
      precio: (data['precio'] != null) ? (data['precio'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'numero_piezas': numeroPiezas,
      'diseno': diseno,
      'imagen': imagen,
      'precio': precio,
    };
  }
}
