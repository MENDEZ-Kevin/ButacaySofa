import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../pages/carrito/carrito_service.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;

  const ProductoCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: Image.network(producto.imagenUrl, width: 80, height: 80, fit: BoxFit.cover),
        title: Text(producto.nombre),
        subtitle: Text(producto.descripcion),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('S/ ${producto.precio.toStringAsFixed(2)}'),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                CarritoService().agregarProducto(producto);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${producto.nombre} agregado al carrito')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}