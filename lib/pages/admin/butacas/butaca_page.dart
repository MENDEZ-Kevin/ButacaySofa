import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'butaca_form.dart';

class ButacasPage extends StatefulWidget {
  const ButacasPage({super.key});

  @override
  State<ButacasPage> createState() => _ButacasPageState();
}

class _ButacasPageState extends State<ButacasPage> {
  List<Map<String, dynamic>> butacas = [];

  @override
  void initState() {
    super.initState();
    obtenerButacas();
  }

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

  Future<void> obtenerButacas() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('productos_butaca').get();

      setState(() {
        butacas = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList();
      });
    } catch (e) {
      print('Error al obtener butacas: $e');
    }
  }

  void _mostrarFormulario([Map<String, dynamic>? butaca]) async {
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ButacaForm(butaca: butaca),
    );

    if (resultado != null) {
      if (butaca == null) {
        // Crear nuevo
        await FirebaseFirestore.instance.collection('productos_butaca').add(resultado);
      } else {
        // Actualizar existente
        await FirebaseFirestore.instance.collection('productos_butaca').doc(butaca['id']).update(resultado);
      }
      obtenerButacas();
    }
  }

  void _eliminarButaca(String id) async {
    await FirebaseFirestore.instance.collection('productos_butaca').doc(id).delete();
    obtenerButacas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Butacas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      body: butacas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: butacas.length,
              itemBuilder: (context, index) {
                final butaca = butacas[index];
                final urlImagenOriginal = butaca['imagenUrl'] as String? ?? '';
                final urlImagenDirecta = convertirEnlaceDriveADirecto(urlImagenOriginal);
                final bool capacidad = butaca['capacidad_giratoria'] ?? false;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: urlImagenOriginal.isNotEmpty
                        ? Image.network(
                            urlImagenDirecta,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.image_not_supported, size: 80),
                    title: Text('Material: ${butaca['material'] ?? 'N/A'}'),
                    subtitle: Text(
                      'Diseño: ${butaca['diseno'] ?? ''}\n'
                      'Capacidad giratoria: ${capacidad ? "Sí" : "No"}\n'
                      'Precio: S/ ${butaca['precio']?.toStringAsFixed(2) ?? "0.00"}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _mostrarFormulario(butaca),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _eliminarButaca(butaca['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
