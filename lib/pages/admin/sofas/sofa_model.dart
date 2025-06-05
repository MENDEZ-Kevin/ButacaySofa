class Sofa {
  final String id;
  final String material;
  final int numeroPiezas;
  final String diseno;
  final String imagen;
  final double precio;  // nuevo atributo

  Sofa({
    required this.id,
    required this.material,
    required this.numeroPiezas,
    required this.diseno,
    required this.imagen,
    required this.precio,  // incluido en constructor
  });

  factory Sofa.fromMap(Map<String, dynamic> data, String id) {
    return Sofa(
      id: id,
      material: data['material'] ?? '',
      numeroPiezas: data['numero_piezas'] ?? 0,
      diseno: data['diseno'] ?? '',
      imagen: data['imagen'] ?? '',
      precio: (data['precio'] != null) ? (data['precio'] as num).toDouble() : 0.0,  // parse seguro a double
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'numero_piezas': numeroPiezas,
      'diseno': diseno,
      'imagen': imagen,
      'precio': precio,  // agregado al mapa
    };
  }
}
// Esta clase representa un sofá con sus atributos y métodos para convertir a y desde un mapa.