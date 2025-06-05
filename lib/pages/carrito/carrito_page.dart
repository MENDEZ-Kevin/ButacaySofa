import 'package:flutter/material.dart';
import '../../models/producto_model.dart';

class CarritoPage extends StatelessWidget {
  final List<Producto> productosEnCarrito;
  final Function(String) onEliminar;

  const CarritoPage({
    super.key,
    required this.productosEnCarrito,
    required this.onEliminar,
  });

  double calcularTotal() {
    return productosEnCarrito.fold(0, (suma, producto) => suma + producto.precio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Carrito')),
      body: productosEnCarrito.isEmpty
          ? const Center(child: Text('Tu carrito está vacío.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productosEnCarrito.length,
                    itemBuilder: (context, index) {
                      final producto = productosEnCarrito[index];
                      return ListTile(
                        leading: producto.imagenUrl.isNotEmpty
                            ? Image.network(producto.imagenUrl, width: 60, height: 60, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported),
                        title: Text(producto.nombre),
                        subtitle: Text('S/ ${producto.precio.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onEliminar(producto.id),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('S/ ${calcularTotal().toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
