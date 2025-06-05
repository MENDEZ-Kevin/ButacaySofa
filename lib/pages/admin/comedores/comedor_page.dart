import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comedor_form.dart';

class ComedoresPage extends StatefulWidget {
  const ComedoresPage({super.key});

  @override
  State<ComedoresPage> createState() => _ComedoresPageState();
}

class _ComedoresPageState extends State<ComedoresPage> {
  List<Map<String, dynamic>> comedores = [];

  @override
  void initState() {
    super.initState();
    obtenerComedores();
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

  Future<void> obtenerComedores() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('productos_comedor').get();
      setState(() {
        comedores = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      });
    } catch (e) {
      print('Error al obtener comedores: $e');
    }
  }

  void _mostrarFormulario([Map<String, dynamic>? comedor]) async {
    await showDialog(
      context: context,
      builder: (_) => ComedorForm(comedor: comedor),
    );
    obtenerComedores();
  }

  void _eliminarComedor(String id) async {
    await FirebaseFirestore.instance.collection('productos_comedor').doc(id).delete();
    obtenerComedores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Comedores')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      body: comedores.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: comedores.length,
              itemBuilder: (context, index) {
                final comedor = comedores[index];
                final urlImagen = convertirEnlaceDriveADirecto(comedor['imagenUrl'] ?? '');
                final precio = comedor['precio'] != null
                    ? 'S/ ${comedor['precio'].toStringAsFixed(2)}'
                    : 'Precio no disponible';

                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 5,
                  child: Column(
                    children: [
                      if (urlImagen.isNotEmpty)
                        Image.network(
                          urlImagen,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ListTile(
                        title: Text('Material: ${comedor['material'] ?? 'N/A'}'),
                        subtitle: Text(
                          'Tipo: ${comedor['tipo_mesa'] ?? 'N/A'}\n'
                          'Capacidad: ${comedor['capacidad_personas']} personas\n'
                          'Precio: $precio',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _mostrarFormulario(comedor)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => _eliminarComedor(comedor['id'])),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
