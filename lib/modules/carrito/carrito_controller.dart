import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'carrito_item_model.dart';

class CarritoController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String material, double precio, {int cantidad = 1}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }
  
    await _firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('carrito')
        .add({ 
          'material': material,
          'precio': precio,
          'cantidad': cantidad, // guardar también cantidad
        });

    notifyListeners();
  }
  
  Future<void> finalizarCompra() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }
    final carritoRef = _firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('carrito');

    final comprasRef = _firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('compras');

    final snapshot = await carritoRef.get();

    if (snapshot.docs.isEmpty) {
      return;
    }
  
    // Primero calculamos el total de la orden
    double total = 0.0;
    List<Map<String, dynamic>> productos = [];

    for (var prod in snapshot.docs) {
      final precio = double.tryParse(prod['precio'].toString()) ?? 0.0;
      final cantidad = int.tryParse(prod['cantidad'].toString()) ?? 1;
      total += precio * cantidad;

      productos.add({...prod.data(), 'cantidad': cantidad});
    }
  
    // Registramos en "compras" toda la orden
    await comprasRef.add({ 
      'fecha': FieldValue.serverTimestamp(), 
      'total': total,
      'productos': productos,
    });

    // Finalmente limpiamos el carrito
    for (var prod in snapshot.docs) {
      await prod.reference.delete();
    }
  }
}
