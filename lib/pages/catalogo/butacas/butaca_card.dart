import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'butaca_model.dart';

class ButacaCard extends StatelessWidget {
  final Butaca butaca;

  const ButacaCard({super.key, required this.butaca});

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
        content: Text('${butaca.material} agregado al carrito'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagenUrl = convertirEnlaceDriveADirecto(butaca.imagenUrl);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'Material: ${butaca.material}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Diseño: ${butaca.diseno}'),
            Text('Capacidad giratoria: ${butaca.capacidadGiratoria ? "Sí" : "No"}'),
            Text('Precio: S/ ${butaca.precio.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => agregarAlCarrito(context),
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

class ButacaList extends StatelessWidget {
  const ButacaList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('butacas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay butacas disponibles'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final butaca = Butaca(
              material: data['material'] ?? 'Desconocido',
              diseno: data['diseno'] ?? 'Sin diseño',
              capacidadGiratoria: data['capacidadGiratoria'] ?? false,
              precio: (data['precio'] ?? 0).toDouble(),
              imagenUrl: data['imagenUrl'] ?? '',
            );
            return ButacaCard(butaca: butaca);
          }).toList(),
        );
      },
    );
  }
}
