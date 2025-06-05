import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cabeceras_form.dart';
import 'cabeceras_model.dart';

class CabecerasPage extends StatefulWidget {
  const CabecerasPage({super.key});

  @override
  State<CabecerasPage> createState() => _CabecerasPageState();
}

class _CabecerasPageState extends State<CabecerasPage> {
  List<Map<String, dynamic>> cabeceras = [];

  @override
  void initState() {
    super.initState();
    obtenerCabeceras();
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

  Future<void> obtenerCabeceras() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('productos_cabeceras').get();

      setState(() {
        cabeceras = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList();
      });
    } catch (e) {
      print('Error al obtener cabeceras: $e');
    }
  }

  void _mostrarFormulario([Map<String, dynamic>? cabecera]) async {
    await showDialog(
      context: context,
      builder: (_) => CabecerasForm(
        cabecera: cabecera == null ? null : Cabecera.fromMap(cabecera, cabecera['id']),
      ),
    );
    obtenerCabeceras();
  }

  void _eliminarCabecera(String id) async {
    await FirebaseFirestore.instance.collection('productos_cabeceras').doc(id).delete();
    obtenerCabeceras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Cabeceras')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      body: cabeceras.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cabeceras.length,
              itemBuilder: (context, index) {
                final cabecera = cabeceras[index];
                final urlImagenOriginal = cabecera['imagenUrl'] as String? ?? '';
                final urlImagenDirecta = convertirEnlaceDriveADirecto(urlImagenOriginal);

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
                        : const Icon(Icons.image_not_supported),
                    title: Text('Altura: ${cabecera['altura'] ?? 'N/A'}'),
                    subtitle: Text(
                      'Material: ${cabecera['material'] ?? 'N/A'}\n'
                      'Diseño: ${cabecera['diseno_decorativo'] ?? ''}\n'
                      'Precio: S/. ${cabecera['precio'] ?? '0.00'}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => _mostrarFormulario(cabecera)),
                        IconButton(icon: const Icon(Icons.delete), onPressed: () => _eliminarCabecera(cabecera['id'])),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
