import 'package:cloud_firestore/cloud_firestore.dart';

class CarritoItem {
  final String id;
  final String material;
  final double precio;
  final int cantidad;

  CarritoItem({required this.id, required this.material, required this.precio, this.cantidad = 1});

  factory CarritoItem.fromDocumentSnapshot(DocumentSnapshot doc) {
    return CarritoItem(
      id: doc.id,
      material: doc['material'] ?? '',
      precio: double.tryParse(doc['precio'].toString()) ?? 0.0,
      cantidad: int.tryParse(doc['cantidad'].toString()) ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'material': material,
      'precio': precio,
      'cantidad': cantidad,
    };
  }
}
