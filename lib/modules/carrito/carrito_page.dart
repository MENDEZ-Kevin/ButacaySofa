import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double _calcularTotal(List<DocumentSnapshot> productos) {
    return productos.fold(0.0, (total, doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final precio = double.tryParse(data['precio']?.toString() ?? '0') ?? 0.0;
      final cantidad = int.tryParse(data['cantidad']?.toString() ?? '1') ?? 1;
      return total + (precio * cantidad);
    });
  }

  Future<void> _eliminarProductoFirebase(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .collection('carrito')
        .doc(id)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto eliminado del carrito')),
    );
  }

  Future<void> _finalizarCompra(List<DocumentSnapshot> productos, double total) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final productosList = productos.map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return {
        'material': data['material'] ?? 'Desconocido',
        'precio': data['precio'] ?? 0.0,
        'cantidad': data['cantidad'] ?? 1,
      };
    }).toList();

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .collection('historial')
        .add({
      'productos': productosList,
      'total': total,
      'fecha': Timestamp.now()
    });

    for (var doc in productos) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('carrito')
          .doc(doc.id)
          .delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Compra finalizada con éxito!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No has iniciado sesión.",
                  style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/landing');
                },
                child: const Text("Iniciar sesión"),
              ),
            ],
          ),
        ),
      );
    }

    final carritoRef = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .collection('carrito');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de compras'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: carritoRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final productos = snapshot.data?.docs ?? [];

          if (productos.isEmpty) {
            return const Center(child: Text('El carrito está vacío.'));
          }

          final total = _calcularTotal(productos);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final prod = productos[index];
                    final data = prod.data() as Map<String, dynamic>? ?? {};

                    final material = data['material']?.toString() ?? 'Sin nombre';
                    final cantidad = int.tryParse(data['cantidad']?.toString() ?? '1') ?? 1;
                    final precio = double.tryParse(data['precio']?.toString() ?? '0') ?? 0.0;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          material,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Cantidad: $cantidad\nPrecio: S/ ${precio.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarProductoFirebase(prod.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.black87,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Total: S/ ${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Comprar ahora'),
                      onPressed: () => _finalizarCompra(productos, total),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        backgroundColor: Colors.green,
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
