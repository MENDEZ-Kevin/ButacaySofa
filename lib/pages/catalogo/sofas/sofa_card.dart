import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sofa_model.dart';

class SofaCard extends StatelessWidget {
  final Sofa sofa;

  const SofaCard({super.key, required this.sofa});

  String convertirEnlaceDriveADirecto(String enlaceDrive) {
    final regExp = RegExp(r'/d/([a-zA-Z0-9_-]+)');
    final match = regExp.firstMatch(enlaceDrive);
    if (match != null && match.groupCount >= 1) {
      final id = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$id';
    } else {
      return enlaceDrive;
    }
  }

  Future<void> _agregarAlCarrito(BuildContext context, int cantidad) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Necesita inicio de sesión')),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('carrito')
          .doc(sofa.id)
          .set({
        'material': sofa.material,
        'diseno': sofa.diseno,
        'numero_piezas': sofa.numeroPiezas,
        'precio': sofa.precio,
        'imagen': sofa.imagen,
        'cantidad': cantidad,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${sofa.material} x$cantidad agregado al carrito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar al carrito: $e')),
      );
    }
  }

  void _mostrarDialogoCantidad(BuildContext context) {
    final TextEditingController cantidadController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar al carrito'),
        content: TextField(
          controller: cantidadController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Cantidad'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Agregar'),
            onPressed: () {
              final int cantidad = int.tryParse(cantidadController.text) ?? 1;

              if (cantidad > 0) {
                _agregarAlCarrito(context, cantidad);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cantidad inválida')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagenUrl = convertirEnlaceDriveADirecto(sofa.imagen);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen agrandada
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imagenUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Material: ${sofa.material}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Diseño: ${sofa.diseno}'),
            Text('Número de piezas: ${sofa.numeroPiezas}'),
            Text('Precio: S/ ${sofa.precio.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _mostrarDialogoCantidad(context),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
