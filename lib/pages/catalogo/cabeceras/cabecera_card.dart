import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cabecera_model.dart';

class CabeceraCard extends StatelessWidget {
  final Cabecera cabecera;

  const CabeceraCard({super.key, required this.cabecera});

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

  void _mostrarSnackBar(BuildContext context, String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _agregarAlCarrito(BuildContext context, int cantidad) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _mostrarSnackBar(context, 'Necesita iniciar sesión', esError: true);
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('carrito')
          .doc(cabecera.id);

      await docRef.set({
        'material': cabecera.material,
        'diseno': cabecera.disenoDecorativo,
        'altura': cabecera.altura,
        'precio': cabecera.precio,
        'imagen': cabecera.imagenUrl,
        'cantidad': cantidad,
      });

      _mostrarSnackBar(context, '${cabecera.material} x$cantidad agregado al carrito');
    } catch (e) {
      _mostrarSnackBar(context, 'Error al agregar al carrito: $e', esError: true);
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
          decoration: const InputDecoration(
            labelText: 'Cantidad',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final int cantidad = int.tryParse(cantidadController.text.trim()) ?? 0;

              if (cantidad > 0) {
                _agregarAlCarrito(context, cantidad);
                Navigator.pop(context);
              } else {
                _mostrarSnackBar(context, 'Cantidad inválida', esError: true);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagenUrl = convertirEnlaceDriveADirecto(cabecera.imagenUrl);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagenUrl,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cabecera.material,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Diseño: ${cabecera.disenoDecorativo}',
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Altura: ${cabecera.altura} m',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'S/ ${cabecera.precio.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, color: Colors.green),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                tooltip: 'Agregar al carrito',
                color: Colors.blue,
                onPressed: () => _mostrarDialogoCantidad(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
