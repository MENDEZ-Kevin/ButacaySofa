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

  void agregarAlCarrito(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${sofa.material} agregado al carrito'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagenUrl = convertirEnlaceDriveADirecto(sofa.imagen);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              imagenUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 50),
            ),
            title: Text('Material: ${sofa.material}'),
            subtitle: Text(
              'Diseño: ${sofa.diseno}\nNúmero de piezas: ${sofa.numeroPiezas}',
            ),
            isThreeLine: true,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 8),
              child: ElevatedButton.icon(
                onPressed: () => agregarAlCarrito(context),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
